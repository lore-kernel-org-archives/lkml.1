Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZLNMt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZLNMt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZLNMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:49:55 -0500
Received: from stinky.trash.net ([213.144.137.162]:61499 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZLNMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:49:54 -0500
Message-ID: <4B263468.3060406@trash.net>
Date: Mon, 14 Dec 2009 13:49:44 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       "" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [RFC 1/2] macvlan: Allow plugging in additional backends
References: <1259862720-28432-1-git-send-email-arnd@arndb.de> <1259862720-28432-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1259862720-28432-2-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> This patch includes only the basic framework for overriding the
> receive path. With these hooks, we can add the macvtap driver
> and potentially other drivers that directly interface with a
> hypervisor.
> 
> Loosely based on a patch by Patrick Mullaney based on another
> patch by Arnd Bergmann.

This patch looks fine to me.
