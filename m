Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZLUC3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZLUC3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 21:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZLUC3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 21:29:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46742
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbZLUC3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 21:29:10 -0500
Date: Sun, 20 Dec 2009 18:29:10 -0800 (PST)
Message-Id: <20091220.182910.226760127.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-12-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091220133800.GA4700@tuxdriver.com>
References: <20091218211945.GC2828@tuxdriver.com>
	<20091220.001736.189688434.davem@davemloft.net>
	<20091220133800.GA4700@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 20 Dec 2009 08:38:00 -0500

> On Sun, Dec 20, 2009 at 12:17:36AM -0800, David Miller wrote:
>> From: "John W. Linville" <linville@tuxdriver.com>
>> Date: Fri, 18 Dec 2009 16:19:45 -0500
>> 
>> > Please let me know if there are problems!
>> 
>> Your tree is based upon Linus's not net-2.6
>> so when I pulled I got a lot of unrelated
>> commits.
>> 
>> Please fix this, thanks.
> 
> It's based on 2.6.33-rc1.  Are you not going to pull that into net-2.6?

Why in the world should I?  There are no conflicts to resolve
that I know of.

And if there are no conflicts to resolve, pulling in Linus's
tree just makes future pulls into his tree more ugly.

This is pretty standard practice, but in any event you shouldn't ever
care.

You should simply always work against net-2.6, there is no reason to
work against any other tree.

This is a pretty fundamental thing, I don't know why you based against
Linus's tree instead of net-2.6.  Now you have to rebase already :-/

