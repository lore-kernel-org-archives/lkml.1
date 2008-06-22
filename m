Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYFVW4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYFVW4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbYFVW40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:56:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58923 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347AbYFVW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:56:25 -0400
Date: Sun, 22 Jun 2008 23:38:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Adam Williamson" <awilliamson@mandriva.com>,
       "Alan Cox" <alan@redhat.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents
 use of device
Message-ID: <20080622233835.47fa8c77@lxorguk.ukuu.org.uk>
In-Reply-To: <20080622140226.5a54de90@infradead.org>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	<4mRZUF-hVeG.A.s6E.JupXIB@albercik>
	<20080622210706.0a90c4ba@lxorguk.ukuu.org.uk>
	<20080622140044.57dce6f2@infradead.org>
	<20080622140226.5a54de90@infradead.org>
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

> > http://www.kerneloops.org/search.php?search=ipaq_open
> > 
> > has a whole slew of different ones.... surprisingly they're almost all
> > with pppd...
> > 
> 
> btw this also shows that this isn't a 2.6.25 regression... 

No suprise about the pppd - that would be the usual usage of this driver.

Alan

