Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYLBUNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYLBUNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLBUNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:13:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51717 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbYLBUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:12 -0500
Date: Tue, 2 Dec 2008 20:13:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [ov511] Export snapshot button through input layer
Message-ID: <20081202201324.7c146ec7@lxorguk.ukuu.org.uk>
In-Reply-To: <1228244823.8307.1458.camel@cookie.hadess.net>
References: <1228244823.8307.1458.camel@cookie.hadess.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 19:07:03 +0000
Bastien Nocera <hadess@hadess.net> wrote:

> Patch says it all.
> 
> Comments appreciated, but please keep me on CC: as I'm not subscribed to

Looks ok - most obvious thing that struck me is the #warn probably wants
to go away ;)

Please see Documentation/SubmittingPatches about Signed-off-by: lines if
you want stuff applied.

Alan
