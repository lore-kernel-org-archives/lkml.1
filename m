Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYGUP2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYGUP2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYGUP16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:27:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57084
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbYGUP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:27:57 -0400
Date: Mon, 21 Jul 2008 08:27:57 -0700 (PDT)
Message-Id: <20080721.082757.103904123.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jeffrey.t.kirsher@intel.com
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721115742.GA4871@martell.zuzino.mipt.ru>
References: <20080720.194856.92564555.davem@davemloft.net>
	<20080720.221106.201055562.davem@davemloft.net>
	<20080721115742.GA4871@martell.zuzino.mipt.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 21 Jul 2008 15:57:42 +0400

> On Sun, Jul 20, 2008 at 10:11:06PM -0700, David Miller wrote:
> > Alexey, please try this patch:
> > 
> > atl1: Do not wake queue before queue has been started.
> 
> Patch helps and networking is back with and without using netconsole,
> thank you!
> 
> Also wan to say, 8139too driver survived multiqueue TX changes fine.

Thank you very much for testing, I'll push this fix.
