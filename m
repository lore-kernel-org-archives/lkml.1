Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXELWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXELWl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 18:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXELWlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 18:41:22 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:13034 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXELWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 18:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UcOgBvM1de4hjprxWGMwdW6Rl/uP99+p6Z9fIMSPkMZNPYn9kKY7QQLJ6dfbDlHoA0ax2IJEGf9o08wBEBm95pLL6OREbM6iCKoXIa+TzSjbOkHUElhI2TQ66/AvnkdrEBhHzHbDXYpwpYcnTDihywbCGVt2Cg6ijAYqP9+/rdQ=
Message-ID: <f6ca9fed0705121541w68511049w85162ba530c62e4b@mail.gmail.com>
Date: Sun, 13 May 2007 00:41:19 +0200
From: "dragoran dragoran" <drago01@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: cfs v11 tests
Cc: mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I tested cfs v11 on 2.6.20.10 and here are my results:
I started 6 md5sum /dev/urandom and 3 glxgears
with 2 glxgears X was still very responsive...but after starting the
third one there where noticeable lags when using X... so I reniced it
to -10 and its very smooth again.
I am now writing this mail with this task in the background...
one more thing: opening a new tab in gnome-terminal has a noticeable
delay same for typing su
I am using compiz with the nvidia 100.14.03 beta drivers on a core 2
duo T7400 x86_64 with a nvidia 7600 Go...
after starting an other md5sum /dev/urandom there are some notice able
delays when typing....
(resending)
p.s: please CC me
