Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbYHEO1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbYHEO1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYHEO1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:27:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38280 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755305AbYHEO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:27:05 -0400
Date: Tue, 5 Aug 2008 15:09:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080805150934.489aae88@lxorguk.ukuu.org.uk>
In-Reply-To: <1217945164.3589.128.camel@twins>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<20080805002618.GA18215@infradead.org>
	<1217897224.27684.66.camel@localhost.localdomain>
	<20080805005415.GA10108@infradead.org>
	<20080805123136.0073e52f@lxorguk.ukuu.org.uk>
	<1217945164.3589.128.camel@twins>
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

> Sure, but what's the point of partial security? It seems to me you're
> not secure until you're fully secure, so why bother with almost?
> 
> Every bug caught with the debuggers is one caught, yay :-)
> 
> Every virus let through is a pawned system, aww :-(

Every bug missed is a crash. Security is not an absolute. If I burst into
your office with a machine gun and ask you for the password your security
system probably fails ...

Security is a risk/reward model.

Alan
