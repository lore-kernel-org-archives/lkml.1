Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZDPKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZDPKBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZDPKA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:00:58 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54379 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbZDPKA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:00:57 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au
Subject: Microblaze fixes for revision
Date: Thu, 16 Apr 2009 11:56:27 +0200
Message-Id: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

here are some patches which fixed some minor things.

There are some categories of patches:
1. Enable some driver for Microblaze - 0011
2. Clean code - 0001, 0003
3. Fix real issue - 0002
4. Do minor changes for future MMU merge - 0004, 0005, 0009
5. Fix sparse errors - 0006, 0007
6. Optional changes - 0008, 0010

All changes are simple and easy to review.

Thanks,
Michal


