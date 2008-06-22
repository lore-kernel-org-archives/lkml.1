Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYFVRVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYFVRVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYFVRUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:20:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58574 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752256AbYFVRUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:20:54 -0400
Date: Sun, 22 Jun 2008 18:03:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hdparm -M acoustic management for sata disks?
Message-ID: <20080622180314.7e24c71a@lxorguk.ukuu.org.uk>
In-Reply-To: <1214066456.18959.6.camel@localhost>
References: <1214043295.17302.16.camel@localhost>
	<485D098E.3080109@rtr.ca>
	<1214066456.18959.6.camel@localhost>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've tried with the 5 sata drives I could get my hands on, they all list
> some recommended acoustic management value but all fail the same way

A lot of drives dropped the acoustic management stuff internally. If I
remember rightly there was a patent dispute about it just after it got
into the ATA standard. 

Alan
