Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZAJR4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZAJR4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 12:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZAJR42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 12:56:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:34843 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752674AbZAJR41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 12:56:27 -0500
X-Authenticated: #1189245
X-Provags-ID: V01U2FsdGVkX19CYCZcfAxCFEw2Vhu2BGy/y9avMm547wCyxEwJ1r
	SKdZnT0OasvjE2
Message-ID: <4968E145.3050807@gmx.net>
Date: Sat, 10 Jan 2009 18:56:21 +0100
From: Carsten Menke <bootsy52@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Russell Cattelan <cattelan@thebarn.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>
Subject: Re: XFS: xfs_trans_cancel Filesystem shutdown
References: <4963B97D.1020201@gmx.net> <49678756.10303@thebarn.com>
In-Reply-To: <49678756.10303@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell Cattelan wrote:
> 
> cc the xfs list.
> 
> Since you have wiped the file system it is going to be hard to get to 
> the bottom of th issue.
> It looks like you hit two different issues here, one is a shutdown and 
> one look like a deadlock?
> 
> 
> In the future it would be helpful to xfs_metadump the file system and 
> then file a bug and attach the metadump image.
> 
Yes, I know, I have seen this after I created the new filesystem while further
searching the net for possible causes of this, that a xfs_metadump is most of 
the time needed to debug this. But as this is a production system the system had 
to go online again as soon as possible, so I just decided
to share the information I've got afterwards. The next time I will do the
xfs_metadump (but then, I hope also that I won't be hit by the problem once again).

Regards

Carsten


-- 
"There are two major products that came out of Berkeley: LSD and UNIX.
   We don't believe this to be a coincidence." --Jeremy S. Anderson
