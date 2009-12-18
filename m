Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZLRRkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZLRRkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZLRRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:40:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbZLRRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:40:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] iplink: add macvlan options for bridge mode
Date: Fri, 18 Dec 2009 18:37:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Anna Fischer <anna.fischer@hp.com>,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       bridge@lists.linux-foundation.org, virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <200912181445.07756.arnd@arndb.de> <20091218092547.4ddfde58@nehalam>
In-Reply-To: <20091218092547.4ddfde58@nehalam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912181837.50242.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0AV9SA7SkIeczLuFyb6ONgwjn+IlQzXngGjb
 XGnA2sjY+Qof6D+GXnW1E98OYU8+QrQvh9J+fW6JKJ7FFGpiJi
 ouH7RuRrD8cU65rg9Jahw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009, Stephen Hemminger wrote:
> On Fri, 18 Dec 2009 14:45:07 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > Ping!
> > 
> > Stephen, I submitted this twice but never heard back from you.
> > The changes to macvlan have been merged in 2.6.33-rc1, so it
> > would be good to have this included as well.
> > 
> >       Arnd
> > 
> 
> iproute gets updated (after patch is in upstream). I haven't started
> on the 2.6.33 version yet.

Ok, thanks for the info. Tell me when/if I should resubmit.
I also have another (smaller) patch that also accepts the same
options for the macvtap driver, which is not upstream.
Should I also send that when the kernel code hits net-next,
2.6.34-rc1 or 2.6.34?

	Arnd
