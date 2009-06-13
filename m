Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZFMRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZFMRri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFMRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 13:47:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:37187 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZFMRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 13:47:29 -0400
Subject: How to unset CONFIG_SERIO_I8042 on x86?
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 13 Jun 2009 19:47:16 +0200
Message-Id: <1244915236.3288.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible? Does it make sense?

I always get this message at boot up on my macbook pro:

[    0.929828] PNP: No PS/2 controller found. Probing ports directly.
[    0.930761] i8042.c: No controller found.
[    0.931038] mice: PS/2 mouse device common for all mice

Or please make these messages warnings only, so I don't see them with
kernel option quiet.

ciao


