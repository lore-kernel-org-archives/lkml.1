Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZBLMmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZBLMmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759120AbZBLMka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:40:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49240 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbZBLMk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:40:28 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090212139.634236515@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/10] x86: MCE: machine check bug fix series
Date: Thu, 12 Feb 2009 13:39:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[sorry for the repost. I typoed email addresses earlier]

This series fixes a couple of bugs that have been 
found in the machine check code in the last few months.

This is currently only the bug fixes, none of the
crypto-contronversal 32bit<->64bit unification patches. 

Near all of it has been submitted and reviewed earlier.

The patches should be merged either into 2.6.29
(to get the bug fixes there) or if that is not possible
or into 2.6.30. They have been tested against 2.6.29-rc4,
but also apply to x86 tip as of 090212.

-Andi
