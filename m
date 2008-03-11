Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYCKScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYCKScO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYCKSbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:31:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60197 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYCKSbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:31:42 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2 nfsd rdma bugfixes for 2.6.25
Date: Tue, 11 Mar 2008 14:31:38 -0400
Message-Id: <1205260300-19127-1-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following server-side nfs rdma patches are bugfixes suitable for
2.6.25.

--b.
