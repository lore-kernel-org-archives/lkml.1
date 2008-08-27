Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYH0OBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYH0OBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbYH0NvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54154 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757751AbYH0NvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:16 -0400
Date: Wed, 27 Aug 2008 14:33:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/59] Introduce credentials
Message-ID: <20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
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

> The wrappings are there to make the implementation of copy-on-write credentials
> easier.

What do we get from copy-on-write credentials ? I've never seen
credentials of any kind showing in profiles so why do we need this ?

Alan

