Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZBUBLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZBUBLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZBUBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:11:24 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53257 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZBUBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:11:23 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/2] GFS2: fix sparse warnings
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 02:11:16 +0100
Message-ID: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes some sparse warnings in GFS2.

---

Hannes Eder (2):
      GFS2: fix sparse warning: Should it be static?
      GFS2: fix sparse warnings: constant is so big it is ...


 fs/gfs2/rgrp.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)
