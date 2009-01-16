Return-Path: <linux-kernel-owner+w=401wt.eu-S936368AbZAPSI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936368AbZAPSI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762505AbZAPSIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:08:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:47969 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761167AbZAPSIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:08:21 -0500
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Quota fixes and improvements
Date: Fri, 16 Jan 2009 19:08:08 +0100
Message-Id: <1232129299-22018-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending for review patches fixing some bugs and implementing new quota
features. First four patches fix possible deadlocks in OCFS2 quotas. I plan
to send them to Linus next week if nobody objects. The remaining patches
are going to linux-next and I plan to merge them in the next merge window.

								Honza
