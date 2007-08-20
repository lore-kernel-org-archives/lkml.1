Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXHTUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXHTUcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764435AbXHTU1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:27:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55558 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764432AbXHTU1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:27:16 -0400
Message-Id: <20070820202600.116795129@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:26:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Sort module list
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:26:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is a repost of the "sort module list patch", needed by the Linux Kernel
Markers.

Applies to 2.6.23-rc2-mm2, in the following order:

seq_file_sorted.patch
module.c-sort-module-list.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
