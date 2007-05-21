Return-Path: <linux-kernel-owner+w=401wt.eu-S1764772AbXEUKQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764772AbXEUKQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXEUKJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:40 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33581 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761430AbXEUKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:19 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510275:sNHT23398550"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 31/32] Blackfin serial driver: implement support for ignoring parity/break errors
Date: Mon, 21 May 2007 18:09:40 +0800
Message-Id: <117974218985-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

