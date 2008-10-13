Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbYJMKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbYJMKF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbYJMJpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:45:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:3133 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763264AbYJMJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:45:50 -0400
X-IronPort-AV: E=Sophos;i="4.33,402,1220241600"; 
   d="scan'208";a="61013697"
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 0/6] Blackfin Serial Driver updates for 2.6.28
Date: Mon, 13 Oct 2008 17:46:19 +0800
Message-Id: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan,

This is Blackfin serial driver updates:

 - rewrite kgdb over serial supporting
 - some bug fixing

Thanks
-Bryan
