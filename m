Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbZKZJwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbZKZJwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZKZJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:52:04 -0500
Received: from verein.lst.de ([213.95.11.210]:46060 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZKZJwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:52:02 -0500
Date: Thu, 26 Nov 2009 10:52:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Christoph Hellwig <hch@lst.de>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Message-ID: <20091126095202.GA15932@lst.de>
References: <20091125102857.GA28310@lst.de> <20091126022311.GB22613@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126022311.GB22613@khazad-dum.debian.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 12:23:11AM -0200, Henrique de Moraes Holschuh wrote:
> If you go back to the previous kernel, does the problem disappear?  Please
> test and report (don't go by past experiences).

Yes - in fact I had to revert to 2.6.31 because 2.6.32-rc is totally
unusable for a kernel developers workload (this issue plus the wifi
disconnects reported elsewhere).

> If it does disappear, what are the highest temperatures your thinkpad hits?

I haven't found a good monitoring applet to do constant monitoring, but
the highest I've seen was around 95C so far.

