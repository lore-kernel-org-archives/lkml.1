Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbXFTKXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbXFTKXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXFTKXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:34 -0400
Received: from mail.suse.de ([195.135.220.2]:48415 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbXFTKXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:34 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [0/10] X86 late bug fixes for 2.6.22
Date: Wed, 20 Jun 2007 12:23:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


All should be added to 2.6.22.

Several of them are minimal bandaids for the release; avoiding
more extensive changes.

And several harmless fixes for various build warnings. 

-Andi
