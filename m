Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638Ab0ATVHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0ATVHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559Ab0ATVHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:07:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab0ATVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:07:02 -0500
Subject: Re: [patch 0/3] sched: Make Priority Inheritance POSIX compliant
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <cbe@osadl.org>,
       Mathias Weber <mathias.weber.mw1@roche.com>
In-Reply-To: <20100120171231.922420383@linutronix.de>
References: <20100120171231.922420383@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 22:06:47 +0100
Message-ID: <1264021607.4283.1118.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 20:58 +0000, Thomas Gleixner wrote:
> The current PI implementation violates POSIX scheduling semantics when
> a thread is deboosted. The following patch series adresses this.
> 
> Thanks and Kudos go to Mathias Weber and Carsten Emde for analysis,
> test cases and initial workaround patches.

These look fine to me,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

