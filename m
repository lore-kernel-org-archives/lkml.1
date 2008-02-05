Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYBEQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYBEQI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYBEQIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:08:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58137 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbYBEQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:08:43 -0500
Date: Tue, 5 Feb 2008 16:03:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glenn Griffin <ggriffin.kernel@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080205160301.7b2369ee@core>
In-Reply-To: <20080205163912.GB23145@one.firstfloor.org>
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com>
	<20080205155558.GA23145@one.firstfloor.org>
	<20080205154213.059ac6e8@core>
	<20080205163912.GB23145@one.firstfloor.org>
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

> Also your sub PC class appliances rarely run LISTEN servers anyways
> that are open to the world.

Really. The ones that first come to mind often have exposed ports
including PDA devices and phones. (Ditto low end PC boxes - portscan an
EEPC some day ;))

Is the other stuff enough - good question, and can be measured easily
enough on a little dlink router or similar.

Alan
