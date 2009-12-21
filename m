Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZLUQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZLUQ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZLUQ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:57:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbZLUQ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:57:12 -0500
Subject: Re: 2.6.33-rc1+ bisected (?) s2ram regression
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos R. Mafra" <crmafra@aei.mpg.de>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091221164608.GA3909@Pilar.aei.mpg.de>
References: <20091221164608.GA3909@Pilar.aei.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 17:56:20 +0100
Message-ID: <1261414580.4314.181.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 17:46 +0100, Carlos R. Mafra wrote:
> After 2.6.33-rc1 suspend to RAM (echo mem > /sys/power/state) stopped working
> on my Vaio. Plain 2.6.33-rc1 is fine.

http://lkml.org/lkml/2009/12/20/88

