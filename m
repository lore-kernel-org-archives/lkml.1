Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611Ab0A0Q4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0A0Q4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400Ab0A0Q4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:56:22 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:45825 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755072Ab0A0Q4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:56:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gAYgyhZC72L/4TLu7wEaeW9nmgCzgH0FT8+9wjBhiFz7eliou9EzbkyxWtIQ9ojuEMfg6CUaRpG4hKNYPiyG0ZVpWyRXTMLe0JEpTNUeJkxwY5tUHj248BikQ856K0v/;
Date: Wed, 27 Jan 2010 08:56:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: davidjon@xenontk.org
Cc: ykzhao <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fix For Korg Bug #14897 (GM45 Display Flicker)
Message-ID: <20100127085603.3ff8b8b2@jbarnes-piketon>
In-Reply-To: <4B6054DA.7090503@xenontk.org>
References: <4B60080E.2000508@xenontk.org>
	<1264600328.10341.29.camel@localhost.localdomain>
	<4B6054DA.7090503@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 20:29:38 +0530
David John <davidjon@xenontk.org> wrote:

> On 01/27/2010 07:22 PM, ykzhao wrote:
> > 
> > Hi, David
> > 	Very good work. Thanks for looking at this issue.
> > 	Do you have an opportunity to try the following patch set on 2.6.33-rc5
> > kernel and see whether the display flicker issue can be fixed?
> > 
> >> http://lists.freedesktop.org/archives/intel-gfx/2010-January/005505.html	
> > 
> > (The first patch can be skipped as it is already in 2.6.33-rc5 kernel).
> > 
> > Thanks.
> > 	Yakui
> > 
> 
> Hi Yakui,
> 
> Your patchset (specifically patch #8) also fixes the problem.
> 
> Can this be merged for 2.6.33?

For .33 your patch is probably best.  For .34 Yakui's cleanups would be
good to apply.

-- 
Jesse Barnes, Intel Open Source Technology Center
