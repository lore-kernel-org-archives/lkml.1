Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYJPUse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYJPUse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYJPUs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:48:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:20725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbYJPUs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QOcLoiU/ZNWyS/HkAfwe3QCdr2LP9EQ+LFCrn8asMERw+6H0lWMXnFtEx/OQZ8zmQA
         mnKHpRYzwMgjQ3IguKwA3Lw6FDO72ej7JvO+g/ZyX5v4BOr6mWg2euhaCU10rs/SmA5t
         5GYHRuBT3BaHMqOKsHqvFC9HbM6mG5bS/N3+A=
Date: Fri, 17 Oct 2008 00:51:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-10-16-00-52 uploaded
Message-ID: <20081016205125.GB2468@x200.localdomain>
References: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org> <Pine.LNX.4.64.0810161336510.14604@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810161336510.14604@shark.he.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 01:38:13PM -0700, Randy.Dunlap wrote:
> On Thu, 16 Oct 2008, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-10-16-00-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27:
> 
> 
> build-r9169.out:ksysfs.c:(.text+0x1a773): undefined reference to `create_proc_profile'
> 
> when CONFIG_PROC_FS=n and CONFIG_SYSFS=n

ksysfs.c is compiled if SYSFS=n?

what's up?
