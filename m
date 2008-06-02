Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYFBTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYFBTu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYFBTuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:50:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43110 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbYFBTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:50:16 -0400
Date: Mon, 2 Jun 2008 20:35:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602203509.466e44e5@core>
In-Reply-To: <20080602172203.GI26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com>
	<20080602075113.60d0fdf8@core>
	<20080602092551.GC26854@enneenne.com>
	<20080602150257.54692f35@core>
	<20080602145603.GG26854@enneenne.com>
	<20080602164840.0dc9cb96@core>
	<20080602172203.GI26854@enneenne.com>
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

> the time precision improved from 5ms to 2ms...
> 
> However, if you prefere that I add the if clause, I'll do it.

I would prefer it - lets get it in, working and tested and then we can
see what can be done about finer details.

