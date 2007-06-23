Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbXFWWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbXFWWIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXFWWIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:08:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55990 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbXFWWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:08:05 -0400
Date: Sat, 23 Jun 2007 23:13:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Grozdan Nikolov <microchip@chello.be>, Torsten Duwe <duwe@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: How innovative is Linux?
Message-ID: <20070623231324.3caca035@the-village.bc.nu>
In-Reply-To: <20070623210228.GY21478@ftp.linux.org.uk>
References: <200706231417.16086.microchip@chello.be>
	<20070623164608.05dc5c30@the-village.bc.nu>
	<200706231812.02317.duwe@lst.de>
	<200706231819.43556.microchip@chello.be>
	<20070623202343.621a244b@the-village.bc.nu>
	<20070623210228.GY21478@ftp.linux.org.uk>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 22:02:29 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> On Sat, Jun 23, 2007 at 08:23:43PM +0100, Alan Cox wrote:
> > Proc type stuff is a lot older than Linux or Unix AFAIK. Loadable modules
> > ditto but the full load/unload/autoload stuff I've not seen pre-Linux.
> 
> Representation of process state and control of that state via files on
> a filesystem? 

I don't know about proc in that sense prior to v8 unix I was thinking
about the logical device stuff and filesystem objects/namepaces that
produced program generated data.



