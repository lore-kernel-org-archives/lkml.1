Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbYA3Jap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbYA3Jap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYA3JaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:15 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:40869 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbYA3JaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:13 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61204638"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] Blackfin serial driver updates
Date: Wed, 30 Jan 2008 17:30:00 +0800
Message-Id: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Blackfin on-chip serial driver bug fixing and updates
 - Add Blackfin board IRQ requirement in 8250 serial driver

