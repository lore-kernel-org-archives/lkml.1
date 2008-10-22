Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYJVPJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYJVPJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbYJVPIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:08:40 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39380 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYJVPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:08:39 -0400
From: Viktor Rosendahl <viktor.rosendahl@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Make sure that any oops is flushed to the mtdoops console
Date: Wed, 22 Oct 2008 18:16:27 +0300
Message-Id: <1224688588-2665-1-git-send-email-viktor.rosendahl@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 22 Oct 2008 15:08:10.0635 (UTC) FILETIME=[FF460DB0:01C93457]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a patch that we have in the N810 kernel to flush the mtdoops console to
flash. I am not sure that this is a proper solution; better ideas are always
appreciated.

best regards,

Viktor
