Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZHLVwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZHLVwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZHLVwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:52:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37211
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbZHLVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:52:30 -0400
Date: Wed, 12 Aug 2009 14:52:40 -0700 (PDT)
Message-Id: <20090812.145240.190966236.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090812182403.GF2657@tuxdriver.com>
References: <20090811183605.GG2634@tuxdriver.com>
	<20090812182403.GF2657@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 12 Aug 2009 14:24:03 -0400

> When you pull this, could you also revert 57921c31 ("libertas: Read
> buffer overflow").  It has been shown to create a new problem.  There
> is work towards a solution to that one, but it isn't a simple clean-up.

Ok, I'll take care of that.
