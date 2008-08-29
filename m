Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYH2KYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYH2KYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYH2KYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:24:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47244 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751804AbYH2KYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:24:09 -0400
Date: Fri, 29 Aug 2008 11:06:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=" <zajec5@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickens" <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
Message-ID: <20080829110641.2310e418@lxorguk.ukuu.org.uk>
In-Reply-To: <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
References: <48B701FB.2020905@goop.org>
	<86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	<48B76CE0.5010309@goop.org>
	<20080829102547.655440bf@lxorguk.ukuu.org.uk>
	<b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
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

> I understand that disabling chunk of RAM on every, even not affected,
> machine is far from perfect, but we have to remember about not
> advanced end-users.

Including not advanced end users without the bug ... which is probably
all but one or two people.
