Return-Path: <linux-kernel-owner+w=401wt.eu-S1422764AbXBPACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422764AbXBPACN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422765AbXBPACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:02:13 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58205 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422764AbXBPACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:02:12 -0500
Date: Fri, 16 Feb 2007 01:02:17 +0100
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.41-rc1
Message-ID: <20070216000217.GJ13958@stusta.de>
References: <20070215175108.GB13958@stusta.de> <200702160149.53177.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702160149.53177.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 01:49:45AM +0200, S.Çağlar Onur wrote:
> Hi;
> 
> 15 Şub 2007 Per tarihinde şunları yazmıştınız:
> > Location:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/
> >
> > git tree:
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git
> >
> >
> > Changes since 2.6.16.40:
> 
> What about CVE-2006-6333, CVE-2006-5753 and CVE-2007-0006?
> 
> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6333

Problem not present in 2.6.16.

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5753

Not a serious security problem, but I'll get it fixed in 2.6.16.42.

> * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0006

Problem is more or less impossible in 2.6.16, but I'll look at it
for 2.6.16.42.

> Cheers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

