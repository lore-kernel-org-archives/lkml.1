Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbZCDIvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbZCDIvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZCDIvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:51:42 -0500
Received: from mail.agmk.net ([91.192.224.71]:60205 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZCDIvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:51:41 -0500
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2009 03:51:41 EST
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.28.7] oops - fatal execption in interrupt.
Date: Wed, 4 Mar 2009 09:23:43 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.28.7-1; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903040923.43241.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

during booting system i get an kernel panic like this:
http://img10.imageshack.us/img10/8017/dsc1120.jpg

additional observations:
- the oops doesn't occur at every boot.
- after oops my jfs filesystem needs deep fsck.

BR,
Pawel.
