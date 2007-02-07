Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXBGSQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXBGSQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030533AbXBGSQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:16:05 -0500
Received: from web38509.mail.mud.yahoo.com ([209.191.125.55]:39843 "HELO
	web38509.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030202AbXBGSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:16:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=o7DkmcBSB80YQ9vjnZ4AvsC2WjLfDOWJbZo74eF9ard+W1po3AHgAB6xbSt4myvMIrbRxOlZp2FtflGNelpUy7/ui9HleV9RpwWkcjRDoXN/IOkvfB4Zvxo5zNxz7UeghCfzQ9qP7Oe/2VvVT/ERu8tXjrxN2wEOWf/JfbsJ7tU=;
X-YMail-OSG: paa5FicVM1kYkO1W6IE.43w_h7vKqE_vZNh_BcxQ_6xVoc_yBsK.TfmRzPrHWzYFST2A0_6S8Bt8HQl_UWcN4Q2y9ulIkW3BrNNpKnYOf_c2A9SClOG_eBlbuIjIz2nPDbMCwdcc8kvucds-
Date: Wed, 7 Feb 2007 10:16:00 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070207100339.2e4c4824.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <922136.78933.qm@web38509.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 7 Feb 2007 09:57:21 -0800 (PST) Levitsky Maxim wrote:
> 
> > Hello,
> > 
> > Before some time I decided to fix suspend/resume on my Davicom network card.
> > During development I also fixed couple of bugs and added support for link detection and WOL
> > Note : 2.6.20 already has support for link detection , but it is broken when card has external
> PHY
> > , like mine.
> > 
> > So here it goes:
> > 
> > [PATCH] [NET] [001] dmfe : trivial/spelling fixes
> > [PATCH] [NET] [002] dmfe : Fix possible oops
> > [PATCH] [NET] [003] dmfe : fix link detection
> > [PATCH] [NET] [004] dmfe : Add suspend/resume support
> > [PATCH] [NET] [005] dmfe : Add support for wake-on-lan
> 
> Hi,
> Please use a different Subject: line for each patch (like you have
> listed them above).
> 
> Also, please send network driver patches to netdev@vger.kernel.org .
> 
> Oops, MAINTAINERS should list netdev@ for DMFE.
> And it does list a maintainer for DMFE, so you should cc: him on
> the patches.
> 
> Thanks.
> ---
> ~Randy
> 

Thanks , its first time I post patches here.
    Maxim levitsky


 
____________________________________________________________________________________
Don't pick lemons.
See all the new 2007 cars at Yahoo! Autos.
http://autos.yahoo.com/new_cars.html 
