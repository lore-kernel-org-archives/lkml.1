Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYLBUvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYLBUvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYLBUvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:51:31 -0500
Received: from mail.atheros.com ([12.36.123.2]:24753 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYLBUva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:51:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <stable@kernel.org>
CC: <ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: several fixes ported to 2.6.27
Date: Tue, 2 Dec 2008 12:51:19 -0800
Message-ID: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.5.6.rc2.15.g457bb.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a few issues seen on MacBook Pros:

http://bugzilla.kernel.org/show_bug.cgi?id=11811

I've ported them to 2.6.27 to help with them being applied sooner.
I've tried to keep them as small as possible. I don't have the
ports for 2.6.28 though I think John will be sending them soon
through his pending-fixes branch.

These are already applied on wireless-testing.

  Luis
