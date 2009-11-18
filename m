Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZKROoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZKROoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbZKROod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:44:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbZKROoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:44:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3] macvlan: Reflect macvlan packets meant for other macvlan devices
Date: Wed, 18 Nov 2009 15:44:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <200911181047.07974.arnd@arndb.de> <m1pr7fdhkx.fsf@fess.ebiederm.org>
In-Reply-To: <m1pr7fdhkx.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181544.24275.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/kRkee7Dz9DTnjcXxSOqJ/kwgMJSybkabYnV4
 br2sSGNXdLPTDp7E2h0xHdSYWC7JoJ8JtYxyiDzuJxfrlwrNJO
 Cdge4jZj6nBA02RVkK3CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Eric W. Biederman wrote:
> Please copy and ideally share code with the veth driver for recycling a skb.
> There are bunch of little things you have to do to get it right.  As I recally
> I was missing a few details in my original patch.

Ok, thanks for the hint!

	Arnd <><
