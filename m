Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYJAQLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYJAQLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYJAQLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:11:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:37853 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYJAQLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:11:16 -0400
Message-Id: <20081001160324.889716972@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 12:03:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [patch 0/5] Markers fixes
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed,  1 Oct 2008 16:10:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are the marker fixes which reenable batch markers
registration/unregistration. They apply to -tip.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
