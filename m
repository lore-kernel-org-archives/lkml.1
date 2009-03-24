Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZCXIXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZCXIXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZCXIWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:22:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:2972 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbZCXIWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=MXns20igqI5EHpUtOcF9RYbfVMeta7lRYsWnL/GK/Y66No+C4WVhOKbm394LKT6zv2
         0Eb5NtkoDsz3MaphikU7rf5ERIjo5NTyvSXe68BLkh9ek0DkASKD174v30TamL0N3ddr
         w5x6N+ZmpVo21gKK/iDETEMoFYCjWQJPmgoPU=
MIME-Version: 1.0
Date: Tue, 24 Mar 2009 19:22:27 +1100
Message-ID: <25ae2d690903240122k3aad9e0dr1080396711daf3c6@mail.gmail.com>
Subject: misspelling on line 1190 of net/ipv4/udp.c .
From: db <db.pub.mail@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hi, i think there is a misspelling of the  word checksumming (if it
is an actual  word ^^) on line 1190 of net/ipv4/udp.c .

The line reads, " * Otherwise, csum completion requires chacksumming
packet body,"

Perhaps the line can be changed to "* Otherwise, csum completion
requires a checksum of the packet body".
