Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZLRR0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZLRR0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZLRR0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:26:13 -0500
Received: from mail.vyatta.com ([76.74.103.46]:34240 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZLRR0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:26:12 -0500
Date: Fri, 18 Dec 2009 09:25:47 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Anna Fischer <anna.fischer@hp.com>,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       bridge@lists.linux-foundation.org, virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Subject: Re: [PATCH] iplink: add macvlan options for bridge mode
Message-ID: <20091218092547.4ddfde58@nehalam>
In-Reply-To: <200912181445.07756.arnd@arndb.de>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de>
	<1258497551-25959-5-git-send-email-arnd@arndb.de>
	<200912181445.07756.arnd@arndb.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 14:45:07 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> Ping!
> 
> Stephen, I submitted this twice but never heard back from you.
> The changes to macvlan have been merged in 2.6.33-rc1, so it
> would be good to have this included as well.
> 
> 	Arnd
> 

iproute gets updated (after patch is in upstream). I haven't started
on the 2.6.33 version yet.
