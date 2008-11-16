Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYKPOVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYKPOVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYKPOVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:21:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:38176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYKPOVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:21:31 -0500
Subject: Re: FYI: BUG in SATA Promise 300 TX4 (2.6.24 - 2.6.27-3) w/Linux
From: Tejun Heo <tj@kernel.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-ide@vger.kernel.org
In-Reply-To: <18719.65298.689618.835202@harpo.it.uu.se>
References: <491C9A4F.1020801@tlinx.org> <491FB7E2.2030105@kernel.org>
	 <18719.65298.689618.835202@harpo.it.uu.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Nov 2008 23:24:43 +0900
Message-Id: <1226845483.20834.1.camel@linux-szv5.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Nov 2008 14:20:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008-11-16 (일), 12:08 +0100, Mikael Pettersson wrote:
>  > Mikael, I think the hardreset fix is worthy including into -stable.
>  > It should be safe for -stable too, right?
> 
> The hardreset fix was included in 2.6.27.5. I wanted it in 2.6.26-stable
> too, but that branch seems to have been closed now.

Ah, right, I was looking at 2.6.26.6 and thinking it was 2.6.27.6.  :-P

Thanks.

--
tejun


