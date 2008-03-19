Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYCSXwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYCSXwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941061AbYCSW0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:26:24 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44451 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941059AbYCSW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:26:21 -0400
From: York Sun <yorksun@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: v2 patch for Freescale DIU driver
Date: Wed, 19 Mar 2008 13:50:25 -0500
Message-Id: <12059526271941-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the version 2 patch for Freescale DIU driver. Thanks for all the feedback.

The first patch is the driver. The second patch adds platform support for MPC8610HPCD board.
To compile, enable the "Freescale MPC8610/MPC5121 DIU framebuffer support" in the menuconfig.
