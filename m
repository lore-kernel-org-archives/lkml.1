Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYGLWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYGLWlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYGLWk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:40:59 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:42184 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYGLWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:40:58 -0400
From: Bernhard Walle <bernhard.walle@gmx.de>
To: x86@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>
Subject: firmware/memmap fixes
Date: Sun, 13 Jul 2008 00:15:31 +0200
Message-Id: <1215900933-27592-1-git-send-email-bernhard.walle@gmx.de>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <20080711173609.8310504d.akpm@linux-foundation.org>
References: <20080711173609.8310504d.akpm@linux-foundation.org>
X-Relay-User: bernhard@bwalle.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the problems Andrew encountered in his review and also fixes a
boot problem on i386 in linux-next. That was not present while testing the
patch in tip tree.

However, I don't know how to merge that patches properly. Directly to
linux-next or via -mm? Or via x86?

The patches are against linux-next tree and were tested on i386.


Signed-off-by: Bernhard Walle <bwalle@suse.de>



