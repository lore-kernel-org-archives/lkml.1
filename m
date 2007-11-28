Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXK1T4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXK1T4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXK1T4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:56:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50865 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbXK1T4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:56:07 -0500
Date: Wed, 28 Nov 2007 19:52:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071128195246.25304758@the-village.bc.nu>
In-Reply-To: <p738x4i9nyd.fsf@crumb.suse.de>
References: <200711281242.52941.tvrtko.ursulin@sophos.com>
	<p738x4i9nyd.fsf@crumb.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It might be better to identify the services (gateway, samba, file
> server whatever) that are actually dealing with possible infected
> "external" files and then define some generic interface that would
> allow you to check those as the data appears.

I am wondering if the right interface is actually more related to the
existing audit interfaces ?

