Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbYFDOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbYFDOYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYFDOYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:24:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34062 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbYFDOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:24:04 -0400
Date: Wed, 4 Jun 2008 15:07:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
Message-ID: <20080604150747.3ec7ee57@core>
In-Reply-To: <1212587753.32207.86.camel@pmac.infradead.org>
References: <48447615.5050806@am.sony.com>
	<1212500751.16924.322.camel@pmac.infradead.org>
	<4845DB46.3020308@am.sony.com>
	<20080604125500.0fce2ea4@core>
	<1212587753.32207.86.camel@pmac.infradead.org>
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

> If I merge this incremental patch, does that address your objections?

Yes

> (Note that I've changed the expression to evaluate (c) only once, just
> because that's best practice in macro definitions. Wasn't really worth
> doing it for (vc) though.)

Agreed
