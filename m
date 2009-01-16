Return-Path: <linux-kernel-owner+w=401wt.eu-S937050AbZAPS3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937050AbZAPS3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbZAPS2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:28:08 -0500
Received: from nxgate.netxen.com ([38.99.60.130]:54441 "EHLO unm84.unmin.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757293AbZAPS2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:28:06 -0500
From: Dhananjay Phadke <dhananjay@netxen.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] netxen fixes
Date: Fri, 16 Jan 2009 10:28:02 -0800
Message-Id: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One to fix build error when IPV6 is unset, other to fix a warning
on ppc64.


