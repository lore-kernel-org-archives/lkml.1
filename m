Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYGERhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYGERhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYGERgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:36:24 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33011 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753088AbYGERgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Ext4 patches for the next merge window
Date: Sat,  5 Jul 2008 13:35:26 -0400
Message-Id: <1215279378-30504-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches are being prepared for pushing to Linus
during the next patch window.  Aside from a large number of cleanups
the big new feature in this patchset is delayed allocation support.

I've been running this patch series on my laptop for the past couple
of days in production, and it's been working quite well for me.

   	   	       	   	     - Ted


