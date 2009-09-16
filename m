Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZIPJnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZIPJnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZIPJnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:43:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:31162 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZIPJm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EEhFemuLt4ZnCpoEPiYMdYQF5SFPT3pSqzpeXGFdcCTxkqpaq/wDifvH9hAbC2cwlo
         XqhHLbOWht8eUJ8oskrUEPW0RYBprPkjLw+ScwPXZFZrkX8aOVuh2LAUfrRIkqF313Z+
         Or4yfkEuIHJA5th1rmvWTYYqE/Wy76x4qDV6U=
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 11:42:58 +0200
Message-ID: <8db1092f0909160242s6856df5ax1bb909272f6c6869@mail.gmail.com>
Subject: WARNING: at mm/backing-dev.c:637 bdi_destroy+0x28/0x70()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.31
Bad: 26.31-git4

During reboot i got:
WARNING: at mm/backing-dev.c:637 bdi_destroy+0x28/0x70()

Screen picture:
http://unixy.pl/maciek/download/kernel/2.6.31-git4/shutdown.jpg

Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.31-git4/dmesg-2.6.31-git4.txt

(also contains warnings about wireless - I reported in another e-mail)

Config:
http://unixy.pl/maciek/download/kernel/2.6.31-git4/config-2.6.31-git4

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
