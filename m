Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYFIKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYFIKpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYFIKph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:45:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57978 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754070AbYFIKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:45:36 -0400
Date: Mon, 9 Jun 2008 11:29:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] Char: mxser, various cleanups
Message-ID: <20080609112914.75486c36@core>
In-Reply-To: <1213006112-25965-7-git-send-email-jirislaby@gmail.com>
References: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
	<1213006112-25965-7-git-send-email-jirislaby@gmail.com>
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

On Mon,  9 Jun 2008 12:08:32 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> - remove unused macro
> - some whitespace cleanup
> - useless debug prints removal
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

And rest of series 

Acked-by: Alan Cox <alan@redhat.com>
