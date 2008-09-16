Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYIPA0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYIPA0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 20:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYIPA0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 20:26:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58788 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbYIPA0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 20:26:14 -0400
Date: Mon, 15 Sep 2008 20:26:13 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Rewrite Linux Makefile name
Message-ID: <20080916002613.GG15421@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is yet another test patch.  It kicks ass, eh?

Not-signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/Makefile b/Makefile
index 4ff83ea..7d06a3e 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@ VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
 EXTRAVERSION = -rc6
-NAME = Rotary Wombat
+NAME = Patch Wombat Numero Dos
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
