Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYHHUwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYHHUwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYHHUwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:52:00 -0400
Received: from www85.your-server.de ([213.133.104.85]:52989 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYHHUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:51:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.26: Filesystem capabilities 0.18
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Fri, 08 Aug 2008 22:15:46 +0200
Message-ID: <87proj2rgt.fsf@rat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: webmaster@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements filesystem capabilities. It allows to
run privileged executables without the need for suid root.

Changes:
- updated to 2.6.26

This patch is available at:
<http://www.olafdietsche.de/linux/capability/>

Regards, Olaf.
