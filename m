Return-Path: <linux-kernel-owner+w=401wt.eu-S1765705AbXGYP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765705AbXGYP1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXGYP1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:27:08 -0400
Received: from mout0.freenet.de ([195.4.92.90]:36906 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbXGYP1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:27:07 -0400
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: John Sigler <linux.kernel@free.fr>
Subject: Re: Pin-pointing the root of unusual application latencies
Date: Wed, 25 Jul 2007 17:28:00 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <469600F7.3060603@free.fr> <20070725133835.GA17616@elte.hu> <46A758B5.9070602@free.fr>
In-Reply-To: <46A758B5.9070602@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251728.00207.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 25. Juli 2007 schrieb John Sigler:
> 
> Is there some form of priority inheritance? Does the IRQ handler get a 
> priority boost if a high priority task is waiting for it?

No. But that would be "nice to have".

      Karsten
