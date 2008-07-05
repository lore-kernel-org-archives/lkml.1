Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYGEF5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYGEF5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 01:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGEF5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 01:57:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYGEF5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 01:57:09 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeff@garzik.org,
       andi@firstfloor.org, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Content-Type: text/plain
Date: Sat, 05 Jul 2008 11:19:18 +0530
Message-Id: <1215236958.4136.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Respected Sirs,

On Sat, Jul 5, 2008 at 2:07 AM, David Miller <davem@davemloft.net>
wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Fri, 04 Jul 2008 14:27:15 +0100
>
>> Your argument makes about as much sense as an argument that we should
>> link b43.ko with mac80211.ko so that the 802.11 core code "rides
along
>> in the module's .ko file". It's just silly.
>
> I totally disagree with you.  Jeff is right and you are wrong.
>

Please let me know, if you found the BUG in the tg3 firmare patch :-
http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=commitdiff;h=be4e9388e35b22d6f8aa104baf39f8339825424e

I will try to fix it.

Thank you,

Jaswinder Singh.

