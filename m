Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYFPMVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYFPMVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYFPMV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:21:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52930 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbYFPMVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:21:25 -0400
Date: Mon, 16 Jun 2008 13:03:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Nameer Yarkon" <nameer.yarkon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serial problem and request for guidance..
Message-ID: <20080616130353.1b80fdd0@lxorguk.ukuu.org.uk>
In-Reply-To: <bec9a5870806160514w79448b53ya622f4752253ae5b@mail.gmail.com>
References: <bec9a5870806160514w79448b53ya622f4752253ae5b@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some of my serial rx data gets lost.

Which hardware ?

> further debug this. Assuming I see the data on the lines
> using a hardware sniffer, but then I do not receive it
> on the host, any idea how I can debug this ?

If you are seeing most of it then I would imagine bytes are being lost
possibly due to latency. Are you trying to do very high speeds, is this a
USB device ?

> Any hunch what it can be ? serial device misconfiguration ?
> 
> Thank you and sorry for such a vague report
> and minimal info...

You need to be much more precise to get any useful recommendations
