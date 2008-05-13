Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbYEMLAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbYEMLAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYEMLAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:00:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33414 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751028AbYEMLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:00:42 -0400
Date: Tue, 13 May 2008 11:50:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
Message-ID: <20080513115009.61d8ad39@core>
In-Reply-To: <87iqxisciu.fsf@basil.nowhere.org>
References: <4388.1210613272@vena.lwn.net>
	<20080512192019.6684f719@core>
	<20080512.135222.266402730.davem@davemloft.net>
	<20080512220834.4449c2d4@core>
	<87iqxisciu.fsf@basil.nowhere.org>
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

> Those would just default to not being credited. Where is the problem?

We need to be sure that people understand that when submitting patches
they must not put Discovered-by: lines in without asking. This is
essentially a documentation matter which is why I directed the original
reply to Jonathan.

Alan
