Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbXFRPMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbXFRPMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbXFRPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:12:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875AbXFRPM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:12:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [GFS2/DLM] Some small bug fixes
Date: Mon, 18 Jun 2007 15:54:26 +0100
Message-Id: <11821784703600-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: y
References: y
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches are the bug fix patches in the current GFS2 -nmw
git tree which I've extracted into the -fixes tree since they are relatively
small and self contained. They are relative to 2.6.22-rc5,

Steve.


