Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYFFPVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYFFPVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbYFFPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:21:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758621AbYFFPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:21:24 -0400
Date: Fri, 6 Jun 2008 16:05:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: hinko.kocevar@cetrtapot.si
Cc: linux-kernel@vger.kernel.org, dev-etrax@axis.com
Subject: Re: [PATCH 2.6.26-rc5 1/2] cris: compile fixes for 2.6.26-rc5
Message-ID: <20080606160541.5c7069e1@core>
In-Reply-To: <484929AA.5030606@cetrtapot.si>
References: <4849213A.4080001@cetrtapot.si>
	<4849218D.7080306@cetrtapot.si>
	<20080606124149.2d87f980@core>
	<484929AA.5030606@cetrtapot.si>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 14:12:26 +0200
Hinko Koc(evar <hinko.kocevar@cetrtapot.si> wrote:

> Stab 2
> 
> Add dummy ops for serial debug port.
> Add setting of c_ispeed/c_ospeed as suggested by Alan Cox.
> 
> Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

Acked-by: Alan Cox <alan@redhat.com>

