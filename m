Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYDGWAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYDGWAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbYDGV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:59:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49580 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbYDGV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:59:47 -0400
Date: Tue, 8 Apr 2008 00:59:45 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: David Miller <davem@davemloft.net>
cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Robin H. Johnson" <robbat2@gentoo.org>,
       Georgi Chorbadzhiyski <gf@unixsol.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Denys Fedoryshchenko <denys@visp.net.lb>,
       Alessandro Suardi <alessandro.suardi@gmail.com>
Subject: Re: [PATCHv2 net-2.6 0/4 (was 0/3)]: TCP fixes
In-Reply-To: <1207569344-19687-1-git-send-email-ilpo.jarvinen@helsinki.fi>
Message-ID: <Pine.LNX.4.64.0804080050060.20948@wrl-59.cs.helsinki.fi>
References: <1207569344-19687-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-335314727-1207605585=:20948"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-335314727-1207605585=:20948
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 7 Apr 2008, Ilpo Järvinen wrote:

> Ok, here's the v2 series 

[...snip...]

> ...So far, they're just compile tested. I'll see if I find some time
> to boot them on the evening.

$ uptime
 00:53:23 up  1:20,  6 users,  load average: 0.54, 0.22, 0.13

...some torrent & browsing, mainly with tso & tcp_sack = 0. Didn't hit 
any problems with it (I had my debug patch in as well).


-- 
 i.
---696208474-335314727-1207605585=:20948--
