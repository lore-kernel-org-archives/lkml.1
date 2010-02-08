Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0BHVim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:38:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58705 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259Ab0BHVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:38:40 -0500
Date: Mon, 8 Feb 2010 21:38:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v2 00/41] CAPI: Major rework, tons of bug fixes
Message-ID: <20100208213859.1ee8241a@lxorguk.ukuu.org.uk>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  o reworked locking of the NCCI TTY using latest and greatest tty_port
>    features and kref, hopefully in the right way

Looks sane to me

Alan
