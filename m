Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbYHHUh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbYHHUh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYHHUhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:37:47 -0400
Received: from www85.your-server.de ([213.133.104.85]:52491 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYHHUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:37:47 -0400
X-Greylist: delayed 1325 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 16:37:46 EDT
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.26: access permission filesystem 0.21
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Fri, 08 Aug 2008 22:15:31 +0200
Message-ID: <87wsir2rh8.fsf@rat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: webmaster@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new permission managing file system.
Furthermore, it adds two modules, which make use of this file system.

One module allows granting capabilities based on user-/groupid. The
second module allows to grant access to lower numbered ports based on
user-/groupid, too.

Changes:
- updated to 2.6.26

This patch is available at:
<http://www.olafdietsche.de/linux/accessfs/>

Regards, Olaf.
