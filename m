Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641Ab0ARV1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0ARV1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413Ab0ARV1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:27:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0ARV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:27:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid removal
Date: Mon, 18 Jan 2010 22:28:14 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <4B4E1633.8010700@pardus.org.tr> <201001171444.14551.rjw@sisk.pl> <4B53B8DD.9000809@zytor.com>
In-Reply-To: <4B53B8DD.9000809@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182228.14460.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, H. Peter Anvin wrote:
> CONFIG_X86_CPU_DEBUG really seems to be causing more problems than it
> ever solved.  This is an RFC for immediately deprecating it, and
> schedule it for removal in the 2.6.34 cycle.
> 
> If this was a high value feature, it would be different -- but it's not
> even close.

ACK
