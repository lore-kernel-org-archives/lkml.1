Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYIDLel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYIDLel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIDLed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:34:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35627 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753121AbYIDLec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:34:32 -0400
Date: Thu, 4 Sep 2008 12:34:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pascal GREGIS <pgs@synerway.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SCSI or libata problem with an RDX removable disk
Message-ID: <20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>
In-Reply-To: <20080904095447.GE2814@venus.synerway.com>
References: <20080904095447.GE2814@venus.synerway.com>
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

> Looking to /var/log/messages I have the following logs :

I need the logs where it fails not afterwards - the ones showing the
drive error and where the fs gives up. Without that it is hard to see
what happened.

> My system is :
> linux kernel 2.6.21.1 with some patches :
> - libata-start_stop_management (http://bugs.gentoo.org/attachment.cgi?id=118829)

It would be useful to know if a 2.6.25/2.6.26 kernel without other
patches does the same thing.
> 
> compiled with libata.
> 
> Motherboard ICH6 family (id 2651)
> 
> Does anyone know this problem or have an idea about what it is and what to do?

Insufficient information to guess right now.
