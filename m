Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbXLQQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbXLQQG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXLQQGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:06:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53348 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760283AbXLQQGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:06:46 -0500
Date: Mon, 17 Dec 2007 15:59:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: taow@alcor.concordia.ca
Cc: "Steven Winikoff" <smw@alcor.concordia.ca>, linux-kernel@vger.kernel.org,
       "Sheila Ettinger" <sheilae@alcor.concordia.ca>,
       "Tan Bui" <tan@alcor.concordia.ca>,
       "Tao Wang" <taow@alcor.concordia.ca>,
       "Gillian Roper" <groper@alcor.concordia.ca>,
       "Sylvain Robitaille" <syl@alcor.concordia.ca>
Subject: Re: 2.6.23.8: OOM killer kills wrong jobs
Message-ID: <20071217155910.278020c4@the-village.bc.nu>
In-Reply-To: <1241.65.94.28.163.1197906245.squirrel@webmail.concordia.ca>
References: <9xMQB-5XC-25@gated-at.bofh.it>
	<9xHQH-6oR-5@gated-at.bofh.it>
	<304323.1197868809@alcor.concordia.ca>
	<20071217133053.508dbab0@the-village.bc.nu>
	<1241.65.94.28.163.1197906245.squirrel@webmail.concordia.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 10:44:05 -0500 (EST)
taow@alcor.concordia.ca wrote:

> > You will *probably* get stable 16GB with the vendor tuned enterprise
> > kernels (RHEL, CentOS etc),
> 
> That's sounds "a little" relief. Thesis 1,2,3 has 16GB memory. Aries has 12G.

If you can run a 64bit kernel, it will save you an inordinate amount of
pain on a box with > 4GB of RAM. The fact > 4GB is possible on such a box
in 32bit doesn't make it a good idea.

Alan
