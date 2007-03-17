Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXCQMlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXCQMlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCQMlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:41:08 -0400
Received: from www17.your-server.de ([213.133.104.17]:3347 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724AbXCQMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:41:07 -0400
Message-ID: <45FBE22A.8030304@m3y3r.de>
Date: Sat, 17 Mar 2007 13:42:18 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Bug in pci_restore_msi_state
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody.

I get this bug after suspending to disk twice:

http://m3y3r.de/bilder/Bug-pci_restore_msi_state.png

This happens with current git head cd05a1f818073a623455a58e756c5b419fc98db9.



