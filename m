Return-Path: <linux-kernel-owner+w=401wt.eu-S1422905AbXBGVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422905AbXBGVgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXBGVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:36:24 -0500
Received: from web38507.mail.mud.yahoo.com ([209.191.125.53]:41586 "HELO
	web38507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422905AbXBGVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:36:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=pVSPJBJta0mracy+ODla3tJE2FGG55UUmhBKKWcTNU+BfAWU0vRbrIk6fZVP0+p8+Mkj42UQ7CukjOKgibjcNJ79T6VxoWflvOAkjLw84XxELoB/4HOBUV7bwVMqDsvCJ5k4GPST8pxjsonIqvqFSH/JQUdzuNZblHombGuw8II=;
X-YMail-OSG: UhFLvUUVM1ncWUp6Ym0qfEKqJGdtNtopVTbnLk0CQIBYA7i1lzO2GIUJJWnBusaEucR79sGR0o_UUIUoWH80Hs1MyjHxs7ZO9UvKdftDMZyz8AiKayl0cq1nCScpkirUsT9kqGG.Kv5HkEQ-
Date: Wed, 7 Feb 2007 13:36:21 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
To: ismail@pardus.org.tr
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702072113.02951.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <949474.11280.qm@web38507.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Ismail Dönmez <ismail@pardus.org.tr> wrote:

> Hi,
> On Wednesday 07 February 2007 19:57:21 you wrote:
> > Hello,
> >
> > Before some time I decided to fix suspend/resume on my Davicom network
> > card. During development I also fixed couple of bugs and added support for
> > link detection and WOL Note : 2.6.20 already has support for link detection
> > , but it is broken when card has external PHY , like mine.
> >
> > So here it goes:
> >
> > [PATCH] [NET] [001] dmfe : trivial/spelling fixes
> > [PATCH] [NET] [002] dmfe : Fix possible oops
> > [PATCH] [NET] [003] dmfe : fix link detection
> > [PATCH] [NET] [004] dmfe : Add suspend/resume support
> > [PATCH] [NET] [005] dmfe : Add support for wake-on-lan
> 
> 
> CC netdev@vger.kernel.org for network patches.
> 
> Regards,
> ismail
> 

I sended all pathes again and I CC'd both maintainer and netdev@vger.kernel.org

     Sincerely,
        Maxim Levitsky


 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
