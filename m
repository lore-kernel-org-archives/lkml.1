Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbZLOXcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbZLOXcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbZLOXc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:32:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52322
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759350AbZLOXc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:32:27 -0500
Date: Tue, 15 Dec 2009 15:32:27 -0800 (PST)
Message-Id: <20091215.153227.173536333.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/3] X25: Move SYSCTL ifdefs into header
From: David Miller <davem@davemloft.net>
In-Reply-To: <d45a3acc0912151526n2de0a64bh3dc0221fc2720d3e@mail.gmail.com>
References: <d45a3acc0912141402v69ea4ccet143f8ef7bc04e585@mail.gmail.com>
	<20091214.214923.241454954.davem@davemloft.net>
	<d45a3acc0912151526n2de0a64bh3dc0221fc2720d3e@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: andrew hendry <andrew.hendry@gmail.com>
Date: Wed, 16 Dec 2009 10:26:19 +1100

> Sorry, ignore these resends, all 3 are were in net-2.6 and made it to linux-next
> 2f5517aefcfbdd7fdf0f03b13d292a10d445887f
> 1fd975a0520cdb27681855d5a18526e328d36b5c
> 429d33ace5ce6122817f8abe9d170eaa55dc3af9
> I'll watch git in the future, not the mailing list pull requests to track.

Another good place to check is patchwork:

http://patchwork.ozlabs.org/patch/39256/
http://patchwork.ozlabs.org/patch/39257/
http://patchwork.ozlabs.org/patch/39258/

All of those patches were put into state "applied".

New patches show up at:

http://patchwork.ozlabs.org/project/netdev/list/
