Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYLDCql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYLDCql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYLDCqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:46:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:35704 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYLDCqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aViiTPIlPv+zQh0oe4aAKBzqQhaSkrV4RyI26qQovG2qOZdYzFBq63mJrBx1+ik6s6
         cCCPAGJf3+KRNGwi5wJ9SMQyX/9EoDlJy75yoSeJAXvmiDLUvLpNLMKFSuPspLpKBCSX
         upw+MBYhNNKFKNCJIXPZYX0sgLcJTVF1qbW6I=
Message-ID: <4937447F.6070805@gmail.com>
Date: Thu, 04 Dec 2008 03:46:23 +0100
From: =?ISO-8859-1?Q?=22Niklas_=5C=22Nille=5C=22_=C5kerstr=F6m=22?= 
	<nille.kungen@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Robby Workman <rw@rlworkman.net>
Subject: sony-ericsson W800 cellular doesn't work as an usb mass storage device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC any replies; not subscribed to list

I can't mount my sony-ericsson W800 cellular as an usb mass storage device (it doesn't show up as an device).
I run slackware-current (slackware 12.2 rc1)
Using kernel 2.6.27.7
It doesn't even show up when i run 'fdisk -l'

How ever running slackware 12.1 using kernel 2.6.24.5 works (used my other box for 12.1 testing)
I also tried the 12.1 kernel 2.6.24.5 in slackware 12.2 rc1 and then it works.
So it's seems kernel related. (but i'm not experienced enuff to know)

Kernel config 2.6.27.7 http://pastebin.com/m4ba5debe
Kernel config 2.6.24.5 http://pastebin.com/m20a78c4f
dmesg when pluging in the device on 2.6.27.7 http://pastebin.com/m56d5e2e8
dmesg when pluging in the device on 2.6.24.5 running 12.1 http://pastebin.com/m65e4fd04
dmesg when pluging in the device on 2.6.24.5 running current http://pastebin.com/m2ac79d09

My computer is an Compaq Presario 2800
Phone Sony Ericsson W800i 0fce:d028
What other information would be useful?

I searched the mailing list and found http://lkml.org/lkml/2008/9/11/276 which seems releated but there was no answer.

(please cc me on any reply)
Thanks,
Nille

