Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXIFAlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXIFAlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 20:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932193AbXIFAk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 20:40:58 -0400
Received: from mobileweb01.london.02.net ([193.113.235.167]:57779 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932257AbXIFAk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 20:40:57 -0400
Date: Thu, 6 Sep 2007 01:31:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Karl Bellve" <Karl.Bellve@umassmed.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI: Unable to reserve mem region problem
Message-ID: <20070906013145.1c14557e@the-village.bc.nu>
In-Reply-To: <46DEBE06.5010401@umassmed.edu>
References: <46DEBE06.5010401@umassmed.edu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2007 10:32:38 -0400
"Karl Bellve" <Karl.Bellve@umassmed.edu> wrote:

> 
> Please CC any response. Thanks.
> 
> I am having an issue with a Supermicro h8dce motherboard and failure to 
> recognize a 5th SATA drive after upgrading to Fedora 7.

Can you send me an lspci -vvxxx so that I can look into this. Might be a
few days with the kernel summit but it should give a clue and may be
linked to ADMA mode

