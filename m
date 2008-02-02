Return-Path: <linux-kernel-owner+w=401wt.eu-S934600AbYBBUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbYBBUoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYBBUoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:44:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:41586 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbYBBUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:44:05 -0500
Message-Id: <20080202204218.188248631@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:42:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/2] x86 : Enhance DEBUG_RODATA support
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:43:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

These patches enhances the DEBUG_RODATA support of the x86 architecture.

They apply on top of 2.6.24-git12 in this order :

#Enhance DEBUG_RODATA support
x86-enhance-debug-rodata-support-alternatives.patch
x86-enhance-debug-rodata-support-for-hotplug-and-kprobes.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
