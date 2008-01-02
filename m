Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYABDuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYABDuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYABDuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:50:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbYABDuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:50:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: gitignore arch/x86/vdso files
In-Reply-To: Sam Ravnborg's message of  Sunday, 30 December 2007 22:41:27 +0100 <20071230214127.GA16421@uranus.ravnborg.org>
References: <20071230214127.GA16421@uranus.ravnborg.org>
X-Shopping-List: (1) Prevalent rubber
   (2) Perspicacious gold
   (3) Musical flammable concussion battalions
   (4) Absorbent excellent salmon
Message-Id: <20080102034958.4381026F99F@magilla.localdomain>
Date: Tue,  1 Jan 2008 19:49:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd make those *.lds or at least vdso*.lds, since it is more likely there
will be other variants than that there will be any .lds source files (since
they are .lds.S instead).


Thanks,
Roland
