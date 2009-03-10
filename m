Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZCJCNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZCJCNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZCJCNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:13:14 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:35161 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbZCJCNN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:13:13 -0400
Message-ID: <49B5CCB7.5030404@lougher.demon.co.uk>
Date: Tue, 10 Mar 2009 02:13:11 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
References: <49AF30EC.8010205@lougher.demon.co.uk> <200903092239.13078.s.L-H@gmx.de>
In-Reply-To: <200903092239.13078.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Lippers-Hollmann wrote:

> 
> This patch seems to break squashfs for me on i386 and amd64. 
> 
> Test environment is a squashed filesystem image (live CD image, but also 
> tested manually with a loop mounted iso9660 and loop mounted squashfs; 
> kernel 2.6.29-rc7-git2). The squashfs image has been created with 
> squashfs-tools CVS[1] as of today (latest commit 2009-03-03).
> 

Hi,

Can you send me a filesystem (or link to one) which exhibits this?  Zlib 
is obviously showing unexpected behaviour...

Thanks

Phillip

