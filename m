Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbXLCUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbXLCUQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXLCUQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:16:22 -0500
Received: from mail.transmode.se ([83.241.175.147]:26852 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbXLCUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:16:22 -0500
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: <linux-kernel@vger.kernel.org>
Subject: what happened to RELATIME?
Date: Mon, 3 Dec 2007 21:16:15 +0100
Message-ID: <056a01c835e9$5b7203f0$5267a8c0@Jocke>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
thread-index: Acg16VsQAtvDah9dQ6y0h95MHF1XsA==
X-OriginalArrivalTime: 03 Dec 2007 20:16:19.0120 (UTC) FILETIME=[5D6DFB00:01C835E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking in 2.6.23 sources it seems like only ocfs2 has added
support for RELATIME. Was RELATIME a bad idea or is there
some other reason other filesystems hasn't added support?

 Jocke

