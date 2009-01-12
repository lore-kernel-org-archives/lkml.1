Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZALUZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZALUZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZALUZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:25:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZALUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:25:03 -0500
Date: Mon, 12 Jan 2009 21:39:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <rdenis@simphalempin.com>
Cc: Andi Kleen <andi@firstfloor.org>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090112203931.GD23848@one.firstfloor.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901122147.57731.rdenis@simphalempin.com> <20090112201435.GC23848@one.firstfloor.org> <200901122215.27842.rdenis@simphalempin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901122215.27842.rdenis@simphalempin.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's the point of writing a parser (that could also have bugs) when the 

Sorry you lost me. What do you mean with parser here?

> kernel can do it?

And what does it have to do with the kernel?

> A normal DVD would be over 30 megabytes per seconds once decoded, just for the 
On many modern systems 30MB/s copies is nothing ... Also in this
case they tend to be cache hot, which makes them much cheaper.

Yes it would be somewhat slower, but if it avoids a couple of security
updates that would be probably worth it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
