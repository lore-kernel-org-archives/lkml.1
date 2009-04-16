Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbZDPFwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbZDPFwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDPFwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:52:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:63060 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZDPFwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:52:00 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: akpm@linux-foundation.org, michael@ellerman.id.au, galak@gate.crashing.org,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [v3 PATCH 3/3] EDAC: CPC925 MC platform device setup
Date: Thu, 16 Apr 2009 13:51:02 +0800
Message-Id: <1239861063-22837-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 16 Apr 2009 05:51:01.0875 (UTC) FILETIME=[52E21430:01C9BE57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew and Michael,

This is the modified 3/3 patch that corrects CPC925 memory controller DTB node on Maple and setup related platform device for CPC925 EDAC driver. Michael's suggestion of being more discernible for the Maple platform only has been adopted.

v2 1/3 & 2/3 patches have been in -mm tree and I don't have to re-send them again. Test passed for this v3 3/3 patch.

Thanks!

Best regards,

Harry
