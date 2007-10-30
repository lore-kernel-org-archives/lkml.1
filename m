Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXJ3LBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXJ3LBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXJ3LBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:01:10 -0400
Received: from partizan.velesys.com ([213.184.230.195]:57800 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXJ3LBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:01:09 -0400
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Unexport several headers and cleanup
Date: Tue, 30 Oct 2007 13:02:15 +0200
Message-Id: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
X-Mailer: git-send-email 1.5.3.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patches unexport several unneeded(I guess) headers from 
userspace. Patches based on patch posted to linux-kernel@ by Mike Frysinger
in July.
