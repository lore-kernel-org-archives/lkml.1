Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbXBEGkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbXBEGkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXBEGko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:40:44 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46336 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbXBEGko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:40:44 -0500
Date: Mon, 5 Feb 2007 12:10:29 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20 -- Loads of section mismatches
Message-ID: <20070205064029.GA23996@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <a44ae5cd0702041402g14051b58qfeb270a72123e22e@mail.gmail.com> <9e0cf0bf0702041406n50bd5639l66b62647d9c4795e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e0cf0bf0702041406n50bd5639l66b62647d9c4795e@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 12:06:47AM +0200, Alon Bar-Lev wrote:
> On 2/5/07, Miles Lane <miles.lane@gmail.com> wrote:
> >Are any of these worth fixing?
> 
> I am preparing a patch for this.
> I will submit it soon.
> 

Many of those warnings I have already fixed. I had posted quite a few
patches. Looks like some of these have not made into mainline yet.
For ex...

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/x86_64-mm-move-startup_32-in-texthead-section.patch

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/x86_64-mm-break-init-in-two-parts-to-avoid-modpost-warnings.patch

I think I should trace the status of all the patches I had posted.

Thanks
Vivek
