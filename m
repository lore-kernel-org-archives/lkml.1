Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZKPCVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZKPCVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZKPCVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:21:39 -0500
Received: from 175.210.DSNET ([203.110.175.210]:36839 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751923AbZKPCVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:21:39 -0500
From: Jie Yang <Jie.Yang@Atheros.com>
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jay Cliburn <jcliburn@gmail.com>,
       Chris Snook <chris.snook@gmail.com>
Date: Mon, 16 Nov 2009 10:21:39 +0800
Subject: RE: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure.
 	order:8, mode:0x8020
Thread-Topic: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure.
 	order:8, mode:0x8020
Thread-Index: AcpjCU6w2QON91hfStqO5crfBGL70gDWddKw
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A494C18F02B@SHEXMB-01.global.atheros.com>
References: <a44ae5cd0911111141i56c067f2we01cfef857133081@mail.gmail.com>
 <a44ae5cd0911111158w4985a6a0n2b30da3421a1b46b@mail.gmail.com>
In-Reply-To: <a44ae5cd0911111158w4985a6a0n2b30da3421a1b46b@mail.gmail.com>
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

On Thursday, November 12, 2009 3:58 AM
Miles Lane <miles.lane@gmail.com> wrote:
> Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page
> allocation failure. order:8, mode:0x8020
>
> This is completely reproducible with this kernel.  I get the
> error on boot, and then I get it again each time I wake the
> OS from the suspend state.
>
>         Miles
>

hi,     Miles
it seems that after git-pull my git-tag -l
result is
... ...
v2.6.31-rc9
v2.6.32-rc1
v2.6.32-rc3

how can i get the 2.6.32-rc6-git4 version.

best wishes
jie


