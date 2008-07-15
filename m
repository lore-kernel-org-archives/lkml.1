Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbYGQSaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbYGQSaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbYGQS35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:29:57 -0400
Received: from 82-39-188-205.cable.ubr03.benw.blueyonder.co.uk ([82.39.188.205]:38853
	"EHLO the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757311AbYGQS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:29:56 -0400
Date: Tue, 15 Jul 2008 13:42:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-ID: <20080715134246.7bee32b1@the-village.bc.nu>
In-Reply-To: <487C500F.8000109@garzik.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<20080714164119.99c33d5b.akpm@linux-foundation.org>
	<20080714165956.7fe2d4ee@infradead.org>
	<487C0365.5030203@garzik.org>
	<alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	<487C09EB.1050903@garzik.org>
	<alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
	<487C1648.5070409@garzik.org>
	<alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
	<487C500F.8000109@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * the legal subtext of these changes was not mentioned at all

The only legal subtext has been some mad fantasy proposed by Dave Miller
that David Woodhouse current employer and previous one were both in some
conspiracy to push firmware elsewhere. It would be very helpful if you
stuck to the real world.

The only legal agenda people I know actually don't like request_firmware
because it makes it easier to have non-free firmware files. In their
strange world they'd rather delete the driver
