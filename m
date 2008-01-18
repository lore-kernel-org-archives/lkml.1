Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbYARR12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbYARR12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbYARR1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:18 -0500
Received: from mx1.suse.de ([195.135.220.2]:53237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304AbYARR1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:17 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [0/7] Add noclflush option and related cleanup
Date: Fri, 18 Jan 2008 18:27:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I added a noclflush option because Ingo asked for it to make
it possible to disable parts of the new CPA code.

While I was at it I did some generic cleanup in the area of cpuid disable 
options and generalized them a bit. That is where the other patches come from.

-Andi
