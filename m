Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYH0Kcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYH0Kcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYH0Kcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:32:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46722
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbYH0Kcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:32:42 -0400
Date: Wed, 27 Aug 2008 03:32:37 -0700 (PDT)
Message-Id: <20080827.033237.236091327.davem@davemloft.net>
To: tomasw@gmail.com
Cc: holtmann@linux.intel.com, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <1ba2fa240808270305m7f505efak9fd0d36d5db09a1e@mail.gmail.com>
References: <20080827.014041.230100807.davem@davemloft.net>
	<1219835410.5359.24.camel@californication>
	<1ba2fa240808270305m7f505efak9fd0d36d5db09a1e@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tomas Winkler" <tomasw@gmail.com>
Date: Wed, 27 Aug 2008 13:05:23 +0300

> There is a central problem here, since I cannot really adjust driver
> development progress from obvious reason with Linux merging window.

Indeed, that's exactly what your core problem is.

You think it's OK to contaminate upstream just because of the
way you have choosen to maintain your driver.

Well guess what, it's not OK to do that, and it's absolutely not our
problem that you choose to do your development in the most anti-social
way possible wrt. upstream.

Anyways, keep defending yourself.

If you persist, I can certainly make things _really_ easy, such that
if there isn't a regression list entry for the bug you are fixing and
it isn't mentioned explicitly in your commit message, I simply will
refuse to take your changes outside of the merge window.

It's that simple.

Would you like things to work that way, where I'm a hard ass, or would
you like to stop defending yourself endlessly, and instead start to be
reasonable?

Thanks.
