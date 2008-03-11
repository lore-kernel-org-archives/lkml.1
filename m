Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYCKBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYCKBXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYCKBXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:23:23 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:60248 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYCKBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:23:22 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080311223.655043226@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [0/3] REPOST: Early exception fixes
Date: Tue, 11 Mar 2008 02:23:19 +0100 (CET)
X-OriginalArrivalTime: 11 Mar 2008 01:16:48.0033 (UTC) FILETIME=[93FB4910:01C88315]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly saves some code size and cleans up the code after Roland's 
recent changes.

Please ack or nack.

-Andi
