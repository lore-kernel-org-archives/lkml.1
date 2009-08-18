Return-Path: <linux-kernel-owner+w=401wt.eu-S1751199AbZHREeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbZHREeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZHREeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:34:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38594
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZHREef convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:34:35 -0400
Date: Mon, 17 Aug 2009 21:34:45 -0700 (PDT)
Message-Id: <20090817.213445.74138658.davem@davemloft.net>
To: mspang@csclub.uwaterloo.ca
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Revert netlink ABI change to gnet_stats_basic
From: David Miller <davem@davemloft.net>
In-Reply-To: <118a63b80908161310r69c0810fg247341f09ced8932@mail.gmail.com>
References: <118a63b80908160642j73568637n2f3fa97fc33d8e57@mail.gmail.com>
	<4A885FD1.4030105@gmail.com>
	<118a63b80908161310r69c0810fg247341f09ced8932@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Spang <mspang@csclub.uwaterloo.ca>
Date: Sun, 16 Aug 2009 16:10:12 -0400

> On Sun, Aug 16, 2009 at 3:36 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
>> Michael Spang a écrit :
>>
>> OK, then we are stuck to use a separate definition for user land
>> and kernel land, or risk various side effects, like performance hit
>> and security risk.
>>
>> Thanks a lot Michael
>>
>> [PATCH] net: restore gnet_stats_basic to previous definition
> 
> Applied it and it works for me, thanks.

Applied to net-2.6, thanks everyone.
