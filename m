Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYGOTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYGOTET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbYGOTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:04:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758932AbYGOTEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:04:04 -0400
Date: Tue, 15 Jul 2008 12:02:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487CF29E.5000009@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> <487CF29E.5000009@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> Because people should not be forced to fix all their firmware-related breakage
> immediately, just to boot 2.6.27.

You're continuing to make an argument that doesn't seem to backed up with 
any actual real problems.

Can you point to real breakage? For real people? 

It sounds like your whole argument literally boils down to "one or two 
people doing something really stupid or odd cannot just fix their setup".

What is the real-life situation where copying the firmware with the 
modules (but still as separate files) actually breaks?

IOW, what _is_ this theoretical breakage? And why is it so deadly 
suddenly? Give us real examples that somehow cannot be fixed?

		Linus
