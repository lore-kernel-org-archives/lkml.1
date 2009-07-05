Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZGERlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZGERlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 13:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZGERlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 13:41:14 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49553 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZGERlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 13:41:14 -0400
Date: Sun, 5 Jul 2009 18:47:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
In-Reply-To: <20090705171739.GF4791@lenovo>
Message-ID: <alpine.LFD.2.00.0907051846280.13862@eddie.linux-mips.org>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <20090705165947.GD4791@lenovo> <20090705171251.GE4791@lenovo> <20090705171739.GF4791@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, Cyrill Gorcunov wrote:

> To be precise -- for discrete apic we set this bit manually.

 Ah, OK then.  That didn't use to be the case.

  Maciej
