Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZAWXMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZAWXMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZAWXMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:12:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53079 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757615AbZAWXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:12:41 -0500
Date: Fri, 23 Jan 2009 23:13:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
Message-ID: <20090123231302.39a6b8e2@lxorguk.ukuu.org.uk>
In-Reply-To: <497A14ED.2010707@walrond.org>
References: <497A0164.90409@walrond.org>
	<20090123180033.3e67f542@lxorguk.ukuu.org.uk>
	<497A14ED.2010707@walrond.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sounds likely. Any way I can know for sure?

Turn off the 8250 PnP support and retest is the best way to test that.

