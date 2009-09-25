Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZIYPrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZIYPrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZIYPrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:47:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41619 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753019AbZIYPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:47:01 -0400
Date: Fri, 25 Sep 2009 16:47:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due
 to  commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
Message-ID: <20090925164747.55dab000@lxorguk.ukuu.org.uk>
In-Reply-To: <b6a2187b0909250835g1b72037er13b86bf762fd5e37@mail.gmail.com>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
	<20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
	<b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>
	<20090925115636.5b4b8aca@linux.intel.com>
	<b6a2187b0909250835g1b72037er13b86bf762fd5e37@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this going into Linus's branch soon? Otherwise, please kindly post
> the full patch so that I can test it instead of pulling 400MB from
> Andrew's tree.

I don't have Andrews tty patches here either sorry but I thought he kept
them broken out on kernel.org ?
