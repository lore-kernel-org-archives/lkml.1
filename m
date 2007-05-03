Return-Path: <linux-kernel-owner+w=401wt.eu-S1767583AbXECR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767583AbXECR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767577AbXECR4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:56:16 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:52813 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767569AbXECR4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:56:14 -0400
Subject: [RFC] [Patch 0/3] readahead statistics slimmed down
From: Martin Peschke <mp3@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, swen@vnet.ibm.com
Content-Type: text/plain
Date: Thu, 03 May 2007 19:56:11 +0200
Message-Id: <1178214971.5639.76.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set simplifies the statistics code of the adaptive readahead
feature by using the proposed statistic infrastructure.

Patches are against 2.6.21-rc7-mm2.

[RFC] [Patch 1/3] readahead statistics slimmed down, statistics prereq
[RFC] [Patch 2/3] readahead statistics slimmed down, adapt zfcp
[RFC] [Patch 3/3] readahead statistics slimmed down

Signed-off-by: Martin Peschke <mp3@de.ibm.com>


