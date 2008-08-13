Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYHMOit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYHMOit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYHMOik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:38:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59018 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbYHMOik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:38:40 -0400
Date: Wed, 13 Aug 2008 14:40:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080813144040.30d40ec5@lxorguk.ukuu.org.uk>
In-Reply-To: <OFC8FDDFED.7F31F3B8-ON852574A4.004A3882-852574A4.004BA8FA@us.ibm.com>
References: <20080812223636.1aff373a@lxorguk.ukuu.org.uk>
	<OFC8FDDFED.7F31F3B8-ON852574A4.004A3882-852574A4.004BA8FA@us.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "goodies", the TCG technology does not protect against hardware
> attacks such as replacing the TPM with a bogus device, replacing the
> CRTM hardware, flashing the CRTM using a JTAG cable, lifting a TPM pin>
> and asserting reset, using a JTAG cable to set breakpoints and alter
> memory, etc.
> 
> For this use case, the attack model is a remote, software attack.  The>
> user is not considered the attacker.

Surely if I can replace your TPM with alternative hardware then I can
also replace it with virtualised software traps.

[If there is a good document on this btw please just point me there
instead and I'll go read further]
