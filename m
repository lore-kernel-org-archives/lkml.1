Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZFAIJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZFAIJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZFAIJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:09:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZFAIJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:09:27 -0400
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 2/2] keep on ticking if oprofile is active
From: Andi Kleen <andi@firstfloor.org>
References: <20090528150447.152019714@de.ibm.com>
	<20090528150502.305840931@de.ibm.com>
Date: Mon, 01 Jun 2009 10:09:27 +0200
In-Reply-To: <20090528150502.305840931@de.ibm.com> (Martin Schwidefsky's message of "Thu, 28 May 2009 17:04:49 +0200")
Message-ID: <87vdngcr48.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky <schwidefsky@de.ibm.com> writes:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> On a NOHZ system with oprofile enabled the timer tick should not be

The old style profile=... profiler should do that too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
