Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZIPB0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZIPB0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZIPB0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:26:13 -0400
Received: from mail.agmk.net ([91.192.224.71]:39138 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZIPB0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:26:12 -0400
X-Greylist: delayed 1541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 21:26:12 EDT
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.31] ir-kbd-i2c oops.
Date: Wed, 16 Sep 2009 03:00:28 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-0.3; KDE/4.3.1; x86_64; ; )
Cc: linux-i2c@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200909160300.28382.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

the latest 2.6.31 kernel oopses in ir-kbd-i2c on my box:
afaics the 2.6.28.10 is also affected.

http://imgbin.org/index.php?page=image&id=776
http://imgbin.org/index.php?page=image&id=777
http://imgbin.org/index.php?page=image&id=778

installed pinnacle tv card with infra-red receiver:

05:00.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
        Video Broadcast Decoder (rev d1)
        Subsystem: Pinnacle Systems Inc. PCTV 110i (saa7133)
        Kernel driver in use: saa7134
        Kernel modules: saa7134

if you need i'll provide more information.
please, CC me on reply.

BR, Paweł.
