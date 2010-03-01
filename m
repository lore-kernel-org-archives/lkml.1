Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab0CANZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:25:01 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27978 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0CANY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:24:59 -0500
X-SpamScore: -18
X-BigFish: VPS-18(z21eWz4015Lzz1202hzzz32i87h2a8h6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLULB-02-EU1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] AMD IOMMU fixes for 2.6.34
Date: Mon, 1 Mar 2010 14:24:38 +0100
Message-ID: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
X-OriginalArrivalTime: 01 Mar 2010 13:24:48.0693 (UTC) FILETIME=[911B0E50:01CAB942]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are some fixes I queued up for the amd iommu driver. I plan to send them
to Linus together with the other driver and iommu-api updates in my tree. If
there are any objections against the patches in this set please let me know.

Thanks,

	Joerg


