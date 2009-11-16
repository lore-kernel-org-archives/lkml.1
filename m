Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZKPE1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZKPE1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZKPE1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:27:47 -0500
Received: from 175.210.DSNET ([203.110.175.210]:36660 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752306AbZKPE1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:27:46 -0500
From: Jie Yang <Jie.Yang@Atheros.com>
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jay Cliburn <jcliburn@gmail.com>,
       Chris Snook <chris.snook@gmail.com>
Date: Mon, 16 Nov 2009 12:27:49 +0800
Subject: RE: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure.
 	order:8, mode:0x8020
Thread-Topic: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure.
 	order:8, mode:0x8020
Thread-Index: Acpmc9D5ioTlCvH9RVGiOXhi895NXAAAPNhg
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A494C18F160@SHEXMB-01.global.atheros.com>
References: <a44ae5cd0911111141i56c067f2we01cfef857133081@mail.gmail.com>
	 <a44ae5cd0911111158w4985a6a0n2b30da3421a1b46b@mail.gmail.com>
	 <72981EBCFD196144B7C6999B9FC34A9A494C18F02B@SHEXMB-01.global.atheros.com>
 <a44ae5cd0911152018qf913307n5506fc2772fc5e60@mail.gmail.com>
In-Reply-To: <a44ae5cd0911152018qf913307n5506fc2772fc5e60@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  Sent: Monday, November 16, 2009 12:18 PM
Miles Lane <miles.lane@gmail.com> wrote:

> Cc: LKML; Jay Cliburn; Chris Snook
> Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page
> allocation failure. order:8, mode:0x8020
>
> I download the latest linux tarball in bz2 format from
> ftp.kernel.org and then apply the patches there.  For example:
>
>     tar xvfj linux-2.6.31.tar.bz2
>     cd linux
>     bzcat ../patch-2.4.32-rc6.bz2 | patch -p1
>     bzcat ../patch-2.4.32-rc6-git4.bz2 | patch -p1

just confused, why use the 2.4.X patch??

best wishes
jie
