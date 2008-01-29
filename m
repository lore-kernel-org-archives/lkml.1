Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYA2Wur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYA2Wur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYA2Wui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:50:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60580 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751919AbYA2Wuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:50:37 -0500
Date: Tue, 29 Jan 2008 22:45:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080129224529.4b8016c3@core>
In-Reply-To: <1201641765.18773.35.camel@dv>
References: <1201641765.18773.35.camel@dv>
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

> - it's a fair game to taint the kernel in some way if ndiswrapper has
> been loaded at some point, since tainting per se is just an indicator
> that the kernel has been used in an unsupportable way

That's all the patch appears to do. Se the taint flag.

> - if this change stands, ndiswrapper will be renamed, which would only
> create more confusion and would thus defeat the purpose of tainting

Not a productive approach. It will only harm support for everyone.
