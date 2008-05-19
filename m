Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYESSjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYESSjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYESSj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:39:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47271 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937AbYESSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:39:27 -0400
Date: Mon, 19 May 2008 19:27:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
 logic
Message-ID: <20080519192702.18285adf@core>
In-Reply-To: <20080519165049.GA19896@kroah.com>
References: <20080519144557.19326.74313.stgit@core>
	<20080519165049.GA19896@kroah.com>
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

> If you don't mind, I'll be glad to take this through my tree as you are
> touching the usb-serial drivers so much.  Andrew, any objection to this?

Seems sensible to me.

> >  MAINTAINERS                           |   72 +
> 
> Odd, I don't see you modifing this file in your patch series...

stgit is being a bit flaky it seems.

Alan
