Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbZANOgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbZANOgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZANOfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:35:55 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52204 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZANOfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:35:54 -0500
Date: Wed, 14 Jan 2009 17:36:05 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] alpha: .gitignore vmlinux.lds
Message-ID: <20090114143605.GE10788@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/.gitignore b/arch/alpha/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/alpha/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
