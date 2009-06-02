Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZFBXVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZFBXVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZFBXVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:21:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44587 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZFBXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:21:09 -0400
Date: Tue, 2 Jun 2009 16:21:09 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090602232108.GG7917@plum>
Reply-To: djwong@us.ibm.com
References: <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum> <20090429220037.GA8604@srcf.ucam.org> <20090430072556.GD16737@elte.hu> <20090430095414.GA19462@srcf.ucam.org> <20090430111042.GA12809@elte.hu> <20090430111338.GA21297@srcf.ucam.org> <20090515191219.GH6968@plum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515191219.GH6968@plum>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 12:12:19PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 30, 2009 at 12:13:38PM +0100, Matthew Garrett wrote:
> > On Thu, Apr 30, 2009 at 01:10:42PM +0200, Ingo Molnar wrote:
> > 
> > > thanks - i've applied this and started testing it. I suspect 1-2 
> > > days of test-time should be enough to see if it breaks this box in 
> > > any way.
> > 
> > My recollection was that you'd see the machine limited to 1GHz on every 
> > boot?
> 
> That seems accurate based on my reading of the old thread.
> 
> It's been a couple of weeks; has anyone seen any problems?

Now it's been thirty days since I last heard from anyone.  Has the problem been
fixed by some other means?

--D
