Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZEEDqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZEEDqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932276AbZEEDq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:46:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:42086 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbZEEDqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:46:25 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: akpm@linux-foundation.org, bluesmoke-devel@lists.sourceforge.net
Cc: norsk5@yahoo.com, linux-kernel@vger.kernel.org
Subject: [v0 PATCH 0/1] EDAC: CPC925 MC check routine fixup
Date: Tue,  5 May 2009 11:45:47 +0800
Message-Id: <1241495148-15166-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 05 May 2009 03:45:05.0223 (UTC) FILETIME=[E09DBD70:01C9CD33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

After you had helped to fold my patches for CPC925 EDAC driver to the
mm tree, I found an obvious bug in the memory controller's check rountine. 
Please help add this fixup to the mm tree too. Thanks!

Best regards,

Harry
