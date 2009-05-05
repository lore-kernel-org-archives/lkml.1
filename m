Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZEEDp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZEEDp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbZEEDpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:45:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:42052 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZEEDpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:45:46 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [v0 PATCH 0/1] EDAC: Deleting device soft lockup fix
Date: Tue,  5 May 2009 11:46:19 +0800
Message-Id: <1241495180-15193-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 05 May 2009 03:45:36.0223 (UTC) FILETIME=[F317F6F0:01C9CD33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Doug,

Although the information contained in the patch header says the soft
lockup occurs when deleting AMD8111 EDAC driver that works in INT mode,
it is possible for all the other EDAC drivers, I have witnessed similar
soft lockup scenario on ATCA-F101 blade before when deleting MV64x60 
EDAC module that is in INT mode.

Best regards,

Harry
