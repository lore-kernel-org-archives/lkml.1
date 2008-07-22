Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYGVSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYGVSgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYGVSgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:36:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35543 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbYGVSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:36:24 -0400
Date: Tue, 22 Jul 2008 19:19:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: Firmware breakage
Message-ID: <20080722191910.11eef7c4@lxorguk.ukuu.org.uk>
In-Reply-To: <1216751464.3019.29.camel@shinybook.infradead.org>
References: <20080722173420.6f90556d@lxorguk.ukuu.org.uk>
	<1216748431.3019.6.camel@shinybook.infradead.org>
	<20080722190516.4ee477f4@lxorguk.ukuu.org.uk>
	<1216751464.3019.29.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was planning to build the firmware binaries as part of 'make modules'
> anyway, because Rafael had related problems (not being able to write to
> the NFS-exported kernel tree at all).

Yes I just hit that problem too.

Alan
