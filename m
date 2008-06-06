Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYFFJcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYFFJcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYFFJcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:32:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:62375 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYFFJcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VU1VAuEEtSrNER8Sapivthk++MJ4btZtAbpzCuT6x7Fw1gJxcj3eg2yA7DOlA9GcGK
         ag/q5HhVUmP1Y8xYz7DHLUuue0sUauW/FDBS7IQM4cYVY71qcxvjsAj8nBEp0RlqhpIH
         /oblci9BJkiVC4n57yY7e3JsXuyvT+B8xQx8I=
Message-ID: <a01a16b50806060232u1eff3867u24fecc539fda1d14@mail.gmail.com>
Date: Fri, 6 Jun 2008 11:32:34 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806041802360.2580@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu>
	 <Pine.LNX.4.64.0805311839540.2657@wrl-59.cs.helsinki.fi>
	 <484191BD.8000904@gmail.com>
	 <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
	 <a01a16b50805311325w7f58ca69h93d02af9bc28d2ea@mail.gmail.com>
	 <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
	 <a01a16b50806031710u54b9297bkf1fad9c4f8fd581f@mail.gmail.com>
	 <Pine.LNX.4.64.0806041402211.16829@wrl-59.cs.helsinki.fi>
	 <a01a16b50806040700h1efce63cq2a27b087df0d25be@mail.gmail.com>
	 <Pine.LNX.4.64.0806041802360.2580@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m569XEHl018533

On 04/06/2008, Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi> wrote:> I guess not all of the strace will be necessary anyway. You could first>  leave that out completely and concentrate on the other logs first.
I have now set up a server on my machine and made all logs available.I will follow up with the adress in private email to those that alreadyhave posted in this thread. For others, please ask to receive it.
BR HÃ¥kon LÃ¸vdal
PSI will be away for this weekend.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
