Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYCZLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYCZLQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbYCZLQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:16:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56187
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753556AbYCZLQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:16:27 -0400
Date: Wed, 26 Mar 2008 04:16:26 -0700 (PDT)
Message-Id: <20080326.041626.224135350.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: sparc64 BUG: using smp_processor_id() in preemptible
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803261142.07422.m.kozlowski@tuxland.pl>
References: <alpine.LFD.1.00.0803251856450.2775@woody.linux-foundation.org>
	<200803261142.07422.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Wed, 26 Mar 2008 11:42:07 +0100

> I see lots of these messages on my ultra 60 box.

This is a sparc64 bug.

To be honest I don't run with preemption enabled very often, but
I'll try to clear this up somehow.
