Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbYDNSc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbYDNSc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761808AbYDNScN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:32:13 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55921 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761729AbYDNScL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:32:11 -0400
Date: Mon, 14 Apr 2008 10:35:21 -0700
From: Roman Shaposhnik <rvs@sun.com>
Subject: Re: Reporting bugs and bisection
In-reply-to: <20080414.034116.24468363.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, w@1wt.eu,
       david@lang.hm, sclark46@earthlink.net, johnpol@2ka.mipt.ru, rjw@sisk.pl,
       tilman@imap.cc, Valdis.Kletnieks@vt.edu, lkml@rtr.ca,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, git@vger.kernel.org,
       netdev@vger.kernel.org
Message-id: <1208194521.25663.12.camel@work.sfbay.sun.com>
MIME-version: 1.0
X-Mailer: Evolution 2.8.2
Content-type: text/plain
Content-transfer-encoding: 7BIT
References: <20080414010412.c42dc560.akpm@linux-foundation.org>
 <20080414.013058.149905948.davem@davemloft.net>
 <20080414031530.2507660d.akpm@linux-foundation.org>
 <20080414.034116.24468363.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 03:41 -0700, David Miller wrote:
> I'm getting more and more sensitive to issues on this level over time,
> because I realize that the fundamental issue in all human group issues
> is getting people to "want" to do things.  And "force", in any form,
> tends to be incompatible with "want".  And in particular, people will
> often even shun things they "want" when it is "forced" to them.

Just wanted to add my 2c by mentioning my favorite example of 
"virtual Tom Sawyering" as far as a tedious review process goes:
   http://en.wikipedia.org/wiki/Knuth_reward_check

Which is also quite cheap too -- AFAIK very few of those have ever
been cashed.

Thanks,
Roman.

