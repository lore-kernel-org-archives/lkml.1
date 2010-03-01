Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0CAPR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:17:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0CAPRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:53 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Mon,  1 Mar 2010 15:08:21 +0000
Message-Id: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not so many patches for GFS2 this merge window. The bulk of the changes are
aimed at reducing overheads when caching large numbers of inodes and
the consequent simplification of the umount code,

Steve.

