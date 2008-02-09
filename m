Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYBIN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYBIN5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYBIN47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:56:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44037 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755189AbYBIN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:56:58 -0500
Date: Sat, 9 Feb 2008 13:50:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dougg@torque.net
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Message-ID: <20080209135020.6eca03ac@core>
In-Reply-To: <47AD02C6.70402@torque.net>
References: <20080208153217.5fc42a50@core>
	<47AD02C6.70402@torque.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 20:32:54 -0500
Douglas Gilbert <dougg@torque.net> wrote:

> Alan Cox wrote:
> > The word "illegal" has a precise dictionary meaning of "prohibited by
> > law". 
> 
> Also "contrary to or forbidden by official rules, regulations, etc".

The OED I have here doesn't seem to think so, however if the words are
the ones used in the T10 documentation then I'm happy to drop the patch.

Alan
