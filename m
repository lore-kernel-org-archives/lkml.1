Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYELE3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYELE3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYELE3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:29:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6827 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYELE3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:29:22 -0400
X-IronPort-AV: E=Sophos;i="4.27,471,1204520400"; 
   d="scan'208";a="53384624"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Try to make 8250 serial work on embedded platform
Date: Mon, 12 May 2008 12:29:23 +0800
Message-Id: <1210566565-6205-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan and Andrew,

How do you think of this patch set?

>From Javier:
Without the first, the 8250-class UART does not work with the Blackfin,
and without the second, you get a compilation error if you activate
8250 UARTs. Besides, I think that there is more people using 8250-class
UARTs with a different hardware than the H8606 board.

Thanks
-Bryan

