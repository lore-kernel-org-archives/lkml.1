Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYAHWzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYAHWzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYAHWzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:55:40 -0500
Received: from 25.mail-out.ovh.net ([213.186.37.103]:48052 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753178AbYAHWzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:55:39 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 17:55:39 EST
To: linux-kernel@vger.kernel.org
Subject: forcedeth driver
MIME-Version: 1.0
Date: Tue, 8 Jan 2008 23:48:56 +0100
From: Franck JONCOURT <franck.mail@dthconnex.com>
Message-ID: <55da55e345c2e59bbc531fa857c215b2@localhost>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Running a 2.6.22 kernel and using the forcedeth driver with 
my ethernet card, I noticed this one is not available from
the gigabit section but from the 10-100Mbit section as
__nForce Ethernet Support__.

[quote forcedeth.c]
0.27: 19 Jun 2004: 
       Gigabit support, new descriptor rings,
       added CK804/MCP04 device IDs, code fixes
       for registers, link status and other minor fixes.
[/quote]

Shouldn't it be in the gigabit section ?
Did I miss anything, or maybe this is fixed in the latest 
kernel releases ?

I do not belong to this mailing list, so please, add my 
email address to your CC field.

Thanks.

---
Franck Joncourt
http://www.debian.org/ - http://smhteam.info/wiki/


