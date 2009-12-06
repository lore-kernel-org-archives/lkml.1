Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZLFDAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZLFDAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 22:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbZLFDAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 22:00:38 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:39813 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZLFDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 22:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SxFghZu7die4rDXll54Id+ZJaug1L0Qob0xpTVuS5EUe+9LnWLWhl6ujt7xb8QE8qH
         Upl5IrgQ2Tlr5ylweQ+X803oHttnf1RDdNNpMrAkysHv//P8PN78EdVwUES3YXTFsNGO
         0aLqif52BgDiiP5DvEbGg5jTUjd2Tcev07Gbc=
Message-ID: <4B1B1E59.1030307@gmail.com>
Date: Sat, 05 Dec 2009 22:00:41 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, brice@myri.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] drivers/net: Move && and || to end of previous
 line
References: <4B190A29.5080905@myri.com>	<1259947271.22783.120.camel@Joe-Laptop.home>	<4B1A557D.4080707@gmail.com> <20091205.142126.23618243.davem@davemloft.net>
In-Reply-To: <20091205.142126.23618243.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: William Allen Simpson <william.allen.simpson@gmail.com>
> Date: Sat, 05 Dec 2009 07:43:41 -0500
> 
>> These patches should not be accepted to the main Linus tree.
> 
> You come out of nowhere as a new contributor.  You have to constantly
> ask about policy and other formalities wrt. kernel development.
> 
Because they are not documented.  Oh, and a reminder -- you've not
answered my most recent questions....


> Yet here you are telling us what should or should not go into the
> tree.
> 
> You don't even know what the "merge window" is yet you seem so

That would be one of the questions (which git clone to patch against now)
that you haven't answered.  Silly of me to ask practical questions.


> confident to elicit firm declarations about code policy.
> 
That would be because I've ample experience coding for multiple open
source platforms.  Apparently such experience isn't valued (by you).

But the fact that about 19% of the Linux code base has managed to function
for circa 18 years without this particular coding policy might be a clue!


> That's nothing but blind arrogance.
> 
> Nobody can take you seriously William, really.
> 
Always _such_ a delight interacting with you, and your personal attacks.

Something that *is* in Documentation/ManagementStyle at 147:

     There's just a few simple rules here:
      (1) don't call people d*ckheads (at least not in public)
      (2) learn how to apologize when you forgot rule (1)
