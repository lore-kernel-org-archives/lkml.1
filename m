Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZKBRup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZKBRup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbZKBRuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:50:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090AbZKBRud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:50:33 -0500
Date: Mon, 2 Nov 2009 09:50:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
In-Reply-To: <200911021439.28266.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0911020948290.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010936.10409.rjw@sisk.pl> <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain> <200911021439.28266.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Nov 2009, Rafael J. Wysocki wrote:
> 
> OK, updated patch is appended.

Looks good to me, feel free to push any time (assuming you've gotten 
testing confirmation from the people who reported it). Thanks,

		Linus
