Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZDCGCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZDCGCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZDCGCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:02:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:32856 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZDCGCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:02:33 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [v1 PATCH 0/3] Add CPC925 Memory Controller EDAC drivers
Date: Fri,  3 Apr 2009 13:59:17 +0800
Message-Id: <1238738360-19839-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 03 Apr 2009 06:01:59.0722 (UTC) FILETIME=[B39ED0A0:01C9B421]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Doug and PPC developers,

This is v1 series of patches for CPC925 Memory Controller EDAC driver that works on PPC970FX. I have taken Arnd's suggestion to fold header/source/etc into one file and makes CONFIG_EDAC_CPC925 depend on CONFIG_PPC64.

Please take a look and give your comments, many thanks!

Best regards,

Harry
