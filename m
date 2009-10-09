Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZJIG6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZJIG6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 02:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZJIG6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 02:58:24 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:63365 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbZJIG6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 02:58:23 -0400
MIME-Version: 1.0
Date: Fri, 9 Oct 2009 08:57:45 +0200
X-Google-Sender-Auth: 28ab39f88bebfe2c
Message-ID: <e8eb01770910082357n2d4fa33dk75b6c45f55bebcbd@mail.gmail.com>
Subject: ftdi_sio regresion 2.6.31-r1
From: Zbynek Drlik <drlik.zbynek@kingparking.sk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
After upgrade kernel from 2.6.30 to 2.6.31-r1 my device connected by
ftdi converter stop working. This device use rts/cts handshake.
In this thread
http://www.gossamer-threads.com/lists/linux/kernel/1128189
i see that similar problem is reported, but in my situation, reconnect
doesn't help. Write is ok. Read not ok.

-- 
S pozdravom Drlik Zbynek.

Fakturacna, dodacia adresa:
VILLA PRO s.r.o
Chrapciakova 1
05201 Spisska Nova Ves
ICO: 31682731IC DPH: SK 2020503518
DIC: 2020503518
Tel: +421 904 380 860
Web: www.kingparking.sk
Skype: drlikzbynek ICQ: 365156504 Gtalk: drlik.zbynek@kingparking.sk
