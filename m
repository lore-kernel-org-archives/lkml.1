Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYBCV3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYBCV3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBCV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:29:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:62355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYBCV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:29:25 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.24: access permission filesystem 0.20
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Sun, 03 Feb 2008 22:29:19 +0100
Message-ID: <87prvd4tlc.fsf@goat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+iz0fGKZOc/rurPP67jTx76JyscGJqa34TkO/
 JktkElY0PW+92G+FiUDlSADAMB8hA7v3pd5xDVdTTF6Bv6HcID
 aFCYITeAl32SO8s3PK8FA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new permission managing file system.
Furthermore, it adds two modules, which make use of this file system.

One module allows granting capabilities based on user-/groupid. The
second module allows to grant access to lower numbered ports based on
user-/groupid, too.

Changes:
- updated to 2.6.24

This patch is available at:
<http://www.olafdietsche.de/linux/accessfs/>

Regards, Olaf.
