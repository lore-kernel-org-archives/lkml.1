Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbXIQSqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbXIQSqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXIQSo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:44:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50388 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722AbXIQSo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:44:28 -0400
Message-Id: <20070917184335.904338974@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 17 Sep 2007 14:43:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Sort module list
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 17 Sep 2007 18:44:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the updated sorted module list, required by the linux kernel markers.

It applies to 2.6.23-rc4-mm1 in this order:

seq_file_sorted.patch
module.c-sort-module-list.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
