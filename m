Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbXGCQVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbXGCQVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXGCQVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:21:30 -0400
Received: from web32610.mail.mud.yahoo.com ([68.142.207.237]:27778 "HELO
	web32610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755536AbXGCQV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:21:29 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 12:21:29 EDT
X-YMail-OSG: vkuNRTMVM1lzj2QLgpZkOvG8e55HwsPPOIC1y1y_FeI7nKo88RUGH_v9xxM31y.3CDExjeytn215IU7rtEtfhO4nNQ--
X-RocketYMMF: knobi.rm
Date: Tue, 3 Jul 2007 09:14:47 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: RE: Linux 2.6.22-rc7
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <389565.1744.qm@web32610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Ok, Linux-2.6.22-rc7 is out there.
>
>It's hopefully (almost certainly) the last -rc before the final 2.6.22
>release, and we should be in pretty good shape. The flow of patches
has
>really slowed down and the regression list has shrunk a lot.
>
>The shortlog/diffstat reflects that, with the biggest part of the -rc7
>patch being literally just a power defconfig update.
>
>The patches are mostly trivial fixes, a few new device ID's, and the
>appended shortlog really does pretty much explain it.
>
>Final testing always appreciated, of course,
>
>Linus

 For what it is worth - rc7 compiles and boots here
(HP/DL380G4,2x86_64, 8GB, cciss, 2xtg3). The subjective feeling(*) is
much better that the original RHEL4 kernel and better than 2.6.19 on
the same box.

(*) Our main problem with 2.6 kernels so far is a tendency to really
bad responsiveness under I/O related load.

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
