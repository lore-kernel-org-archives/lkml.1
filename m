Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYGBUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYGBUYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYGBUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:24:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54942
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbYGBUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:24:09 -0400
Date: Wed, 02 Jul 2008 13:24:08 -0700 (PDT)
Message-Id: <20080702.132408.97330339.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-06-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080702193710.GA4682@tuxdriver.com>
References: <20080630215651.GA666@tuxdriver.com>
	<20080702193710.GA4682@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 2 Jul 2008 15:37:10 -0400

> On Mon, Jun 30, 2008 at 05:56:51PM -0400, John W. Linville wrote:
> 
> >       iwlwifi: fix incorrect 5GHz rates reported in monitor mode
> 
> >       iwlwifi: drop skb silently for Tx request in monitor mode
> 
> It looks like these two are appropriate for 2.6.26.  Since you
> haven't pulled this yet, I'll push them that way, drop them from
> wireless-next-2.6, and send a new pull request.

Ok, thanks for the heads up.
