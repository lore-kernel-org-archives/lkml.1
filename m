Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYFVWz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYFVWz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYFVWzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:55:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58917 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755862AbYFVWzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:55:50 -0400
Date: Sun, 22 Jun 2008 23:37:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Williamson <awilliamson@mandriva.com>, Alan Cox <alan@redhat.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents
 use of device
Message-ID: <20080622233720.731f696f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080622211734.GE20122@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	<4mRZUF-hVeG.A.s6E.JupXIB@albercik>
	<20080622210706.0a90c4ba@lxorguk.ukuu.org.uk>
	<20080622140044.57dce6f2@infradead.org>
	<20080622140226.5a54de90@infradead.org>
	<20080622211734.GE20122@cs181140183.pp.htv.fi>
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

> > btw this also shows that this isn't a 2.6.25 regression... 
> 
> That hardly shows it.
> 
> And Adam said quite explicitely that 2.6.25 worked for him.

Nothing much I can do to help. The URB is assigned in setup and is NULL
later. Nothing else I can find touches it.

Alan
