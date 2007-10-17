Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbXJQS2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbXJQS2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbXJQS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:28:21 -0400
Received: from gw.goop.org ([64.81.55.164]:40298 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbXJQS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:28:21 -0400
Message-ID: <47165444.30208@goop.org>
Date: Wed, 17 Oct 2007 11:28:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] paravirt_ops and xen updates for 2.6.24
References: <47150D5E.6090504@goop.org> <47164C89.60400@goop.org> <20071017180626.GA9307@elte.hu>
In-Reply-To: <20071017180626.GA9307@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, could we do the arch/x86 changes via the arch/x86 tree instead? 
> We've got about a 100 patches pending there now, under QA, preparing 
> them for pushout. Will check your paravirt patches too, ok?

Yep, that's fine.

    J

