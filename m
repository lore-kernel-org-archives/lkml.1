Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYLZOTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYLZOTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYLZOTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:19:05 -0500
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:27913 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbYLZOTF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:19:05 -0500
From: Frans Pop <elendil@planet.nl>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: removable media errors
Date: Fri, 26 Dec 2008 15:19:00 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200812260905.22062.gene.heskett@gmail.com>
In-reply-To: <200812260905.22062.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812261519.01003.elendil@planet.nl>
X-OriginalArrivalTime: 26 Dec 2008 14:19:01.0530 (UTC) FILETIME=[E65217A0:01C96764]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought this was fixed as I hadn't seen it for a couple of rc's, but
> its back.
>
> >From the log or logwatch:
>
>  WARNING:  Kernel Errors Present
>     [100771.466400] end_request: I/O error, dev fd0, sector ...:  1 Time(s)
>     [100771.647800] end_request: I/O error, dev sr0, sector ...:  1 Time(s) 
>     [100771.647806] Buffer I/O error on device sr0, l ...:  1 Time(s) 
>     [100771.647809] Buffer I/O error on device sr0, l ...:  1 Time(s)

Have you perhaps been using some kind of emulator or virtualization?
I've seen that causing similar errors.

Cheers,
FJP
