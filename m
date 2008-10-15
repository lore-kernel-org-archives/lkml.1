Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYJORtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYJORtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbYJORtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:49:12 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:35542 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbYJORtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:49:10 -0400
Message-Id: <20081015174215.337001494@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 15 Oct 2008 19:42:15 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 0/5] latest fixes for s390.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Five new bug fixes for s390:

Christian Borntraeger (2):
      [S390] vmcp: remove BKL
      [S390] pgtables: Fix race in enable_sie vs. page table ops

Heiko Carstens (1):
      [S390] Fix sysdev class file creation.

Jan Glauber (2):
      [S390] qdio: prevent double qdio shutdown in case of I/O errors
      [S390] qdio: remove incorrect memset

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

