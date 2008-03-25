Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbYCYV1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbYCYV1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYCYV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:27:23 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:39994 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYCYV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:27:22 -0400
From: York Sun <yorksun@freescale.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl
Subject: V3 Patch - Driver for Freescale 8610 and 5121 DIU
Date: Tue, 25 Mar 2008 16:27:16 -0500
Message-Id: <120648043867-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following two patches are the 3rd version of the DIU patch for Freescale 8610 and 5121.
It fixed the issues according to the feedback from Andrew Morton.

Andrew, incremental patches are available if requested.

Regards,

York
