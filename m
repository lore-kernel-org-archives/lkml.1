Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZFHWAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZFHWAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZFHWAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:00:18 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:59969 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbZFHWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:00:17 -0400
Date: Tue, 9 Jun 2009 00:02:11 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [Security, resend] Instant crash with rtl8169 and large packets
Message-ID: <20090608220211.GA28994@electric-eye.fr.zoreil.com>
References: <4A2D1147.8020101@msgid.tls.msk.ru> <4A2D1FE4.5030100@gmail.com> <4A2D25F6.9080300@msgid.tls.msk.ru> <4A2D2906.6090002@gmail.com> <4A2D301D.9040301@msgid.tls.msk.ru> <4A2D3568.6010901@gmail.com> <4A2D3BC6.3040904@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2D3BC6.3040904@msgid.tls.msk.ru>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> :
[...]
> I'll try out some more tests later today.  (And there's another
> issue with these NICs -- the famous, quite frequent under load
> "NETDEV WATCHDOG: eth0 (r8169): transmit timed out" errors, which
> are quite annoying... Also shown by both the above-mentioned mobos
> and by other machines).

This one should be fixed by commit f11a377b3f4e897d11f0e8d1fc688667e2f19708
in mainline.

-- 
Ueimor
