Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYJXNmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYJXNmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYJXNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:42:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:36697 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751159AbYJXNmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:42:01 -0400
X-Authenticated: #3800222
X-Provags-ID: V01U2FsdGVkX1+Uq8gbPZWUe9+xCAK/bPichKIs4AbG/mYWHUIEi/
	nbnQ2YUwo8AeSh
Message-ID: <4901D0A5.7060707@gmx.de>
Date: Fri, 24 Oct 2008 15:41:57 +0200
From: Joerg Albert <jal2@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       otus-devel@venema.h4ckr.net
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <43e72e890810231637v51591edak5345faccd81d594b@mail.gmail.com>
In-Reply-To: <43e72e890810231637v51591edak5345faccd81d594b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2008 01:37 AM, Luis R. Rodriguez wrote:

> So for those of you who want to know which devices to buy

I'd guess the

* AVM FRITZ!WLAN N USB Stick (USB ID 0x57c, 0x8401)

should be in this list, too.

I don't own one (yet), but the Windows driver contains:
$ strings -t x fwlanusbn_wxp.sys
...
4de20 Atheros OTUS Wireless Network Adapter
...

Could some owner please confirm the chipset of this stick?

