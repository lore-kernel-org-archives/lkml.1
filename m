Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYJMSXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYJMSXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYJMSXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:23:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45413
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYJMSXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:23:33 -0400
Date: Mon, 13 Oct 2008 11:23:09 -0700 (PDT)
Message-Id: <20081013.112309.129955744.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: bunk@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Please pull - generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <m31vyk4kde.fsf@maximus.localdomain>
References: <20081012.144704.39192150.davem@davemloft.net>
	<20081013055356.GA29938@cs181140183.pp.htv.fi>
	<m31vyk4kde.fsf@maximus.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 13 Oct 2008 16:53:17 +0200

> Adrian Bunk <bunk@kernel.org> writes:
> 
> > The over 3 weeks old -next already contains mostly the same as the HDLC 
> > tree contains now.
> >
> > The thing you two should sort out is why the tree ended up as an own 
> > tree in -next instead of pull requests to David long ago.
> >
> > E.g. the netdev and wireless trees also don't go into -next, but instead 
> > with frequent pull requests to David.
> 
> I can't see any problem with this, is there any?
> 
> I want the HDLC tree tested in next before it's merged upstream
> (= David's tree(s)). I don't want to push crap upstream  first and
> only then try to fix it (though a bug still slips in sometimes).

You're supposed to have your changes merged into the relevant
subsystem tree long before Linus's merge window opens up.

That's how it is meant to work.

What I'm doing with networking is nothing special.

So please be punctual and merge early and often to Jeff and
myself, so that you don't miss the merge window in the future.
