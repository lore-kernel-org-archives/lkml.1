Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbYGOVVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbYGOVVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYGOVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:21:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbYGOVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:21:28 -0400
Date: Tue, 15 Jul 2008 14:20:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] x86 updates
In-Reply-To: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Thomas Gleixner wrote:
>
> Please pull the latest x86/urgent git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/urgent

Hmm> "Already up-to-date"?

Also, your other tree seems to also have added annoying warnings:

  arch/x86/kernel/acpi/boot.c: In function ¡acpi_parse_fadt¢:
  arch/x86/kernel/acpi/boot.c:747: warning: format ¡%#x¢ expects type ¡unsigned int¢, but argument 2 has type ¡long unsigned int¢

Grr.

Guys, stop sending me crap. A _little_ bit of testing would be good.

		Linus
