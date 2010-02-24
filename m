Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab0BXNAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:00:11 -0500
Received: from yop.chewa.net ([91.121.105.214]:37199 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456Ab0BXNAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:00:10 -0500
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 08:00:10 EST
To: andrew hendry <andrew.hendry@gmail.com>
Subject: Re: tuntap with =?UTF-8?Q?tun=5Fno=5Fpi=20and=20X=32=35=20question?=
MIME-Version: 1.0
Date: Wed, 24 Feb 2010 13:51:44 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Organization: Remlab.net
In-Reply-To: <d45a3acc1002240352r43e546c7x4a40aa7d8e187369@mail.gmail.com>
References: <d45a3acc1002240352r43e546c7x4a40aa7d8e187369@mail.gmail.com>
Message-ID: <1bf329b2b4fe8fca4f4ea16874643c11@chewa.net>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Feb 2010 22:52:27 +1100, andrew hendry <andrew.hendry@gmail.com>
wrote:
> The 0x40 and 0x60 comes from the first byte of the IP which has the
> version there?

Yes.

> With X.25 the first byte changes depending on the call sequence, so it
> cant be detected and set in the same way.

Then you need to use PI. That's what it's meant for.

-- 
Rémi Denis-Courmont
http://www.remlab.net
http://fi.linkedin.com/in/remidenis

