Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZDMGMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZDMGMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZDMGLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:11:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:51424 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZDMGLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:11:36 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, michael@ellerman.id.au,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [v2 PATCH 0/3] Add CPC925 Memory Controller EDAC drivers
Date: Mon, 13 Apr 2009 14:05:13 +0800
Message-Id: <1239602716-18352-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 13 Apr 2009 06:11:06.0140 (UTC) FILETIME=[A17115C0:01C9BBFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Doug and Michael,

This is the latest v2 patches, the 1/3 of CPC925 MC EDAC driver remains
the same as before, the 2/3 has been pushed to Andrew already, and the 
3/3 has integrated Michael's suggestions to add a fixup routine for the 
memory controller on Maple that has incorrect number of cells, and create
related platform_device for CPC925 on Motorola ATCA-6101 target by far.

All patches have been tested, please give me your further concerns or 
suggestions, thanks!

Best regards,

Harry
