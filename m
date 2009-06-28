Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZF1Sd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZF1Sd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZF1SdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:33:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39119
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbZF1SdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:33:19 -0400
Date: Sun, 28 Jun 2009 11:33:25 -0700 (PDT)
Message-Id: <20090628.113325.244931913.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: joe@perches.com, linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org, Eng.Linux@digi.com
Subject: Re: [PATCH 14/62] drivers/char/epca.c: Remove unnecessary
 semicolons
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090628185102.47663e61@lxorguk.ukuu.org.uk>
References: <cover.1246173664.git.joe@perches.com>
	<1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
	<20090628185102.47663e61@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sun, 28 Jun 2009 18:51:02 +0100

> On Sun, 28 Jun 2009 09:26:19 -0700
> Joe Perches <joe@perches.com> wrote:
> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  drivers/char/epca.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> If you must do this then please roll it into a single patch and get it
> applied so it doesn't mess up all the pending patches. Really though I
> have to ask what the point is - it just makes other patches not apply and
> creates noise work.

It has made bugs get added in the past, and makes code confusing
to read sometimes.  I'm all for this, to be honest, and I'm very
much for rolling this into one single patch too :)
