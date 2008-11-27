Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYK0TS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYK0TS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 14:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYK0TSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 14:18:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39290 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752376AbYK0TSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 14:18:48 -0500
Date: Thu, 27 Nov 2008 19:15:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v3] relatime: Make relatime smarter
Message-ID: <20081127191547.7c9cf6d2@lxorguk.ukuu.org.uk>
In-Reply-To: <20081127165929.GA23366@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org>
	<20081126195824.GB3541@srcf.ucam.org>
	<492DD035.5020705@oracle.com>
	<20081127150126.GA20941@srcf.ucam.org>
	<20081127150341.GB20941@srcf.ucam.org>
	<20081127163535.775729bf@lxorguk.ukuu.org.uk>
	<20081127164754.GC22963@srcf.ucam.org>
	<20081127165929.GA23366@srcf.ucam.org>
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

> +	relatime_interval=
> +			[FS] relative atime update frequency, in seconds.
> +			(default: 1 day: 86400 seconds)

What about leap seconds  ;)

Acked-by: Alan Cox <alan@redhat.com>
