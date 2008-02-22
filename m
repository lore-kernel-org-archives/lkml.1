Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbYBVJwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbYBVJwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbYBVJw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:52:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33092 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753546AbYBVJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:52:25 -0500
Date: Fri, 22 Feb 2008 09:42:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper tainting
Message-ID: <20080222094214.4a9a1da7@core>
In-Reply-To: <1203642175.14339.17.camel@dv>
References: <1203642175.14339.17.camel@dv>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 20:02:55 -0500
Pavel Roskin <proski@gnu.org> wrote:

> Hello!
> 
> What are the chances that incorrect tainting of ndiswrapper will be
> fixed in 2.6.25?  I'm worried that it still hasn't happened in the
> mainline repository.  It's unfortunate to see that a long discussion
> didn't result in a simple fix.  If anyone is waiting for my patch,
> please let me know what kind of patch I'm supposed to submit and to
> which address.

One to Linus and l/k which takes the current tree and fixes it.

Alan
