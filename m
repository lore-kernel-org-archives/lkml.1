Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYCGDGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYCGDGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYCGDFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:05:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:60310 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYCGDFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:05:51 -0500
Subject: Re: [PATCH] Alchemy Semi Au1000 pcmcia driver: convert
	pcmcia_sockets_lock in a mutex
From: Daniel Walker <dwalker@mvista.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080306222246.GD2783@traven>
References: <20080306222246.GD2783@traven>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 19:05:49 -0800
Message-Id: <1204859149.3368.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-06 at 23:22 +0100, Matthias Kaehlcke wrote:
> Alchemy Semi Au1000 pcmcia driver: The semaphore pcmcia_sockets_lock
> is used as a mutex, convert it to the mutex API
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> 
> --
> 
>  #include <linux/interrupt.h>

This doesn't appear to be in patch format .. There no filename at the
top..

Daniel

