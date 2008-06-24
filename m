Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYFXVKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYFXVKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYFXVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:09:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYFXVJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:09:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [GFS2] Some fixes
Date: Tue, 24 Jun 2008 21:20:17 +0100
Message-Id: <12143388193217-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches fix a couple of regressions introduced in the
last merge window. They are fairly small and both fix important bugs,

Steve.


