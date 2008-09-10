Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYIJPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYIJPzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYIJPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:55:23 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:8379 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbYIJPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:55:22 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Time travel experiment?
Date: Wed, 10 Sep 2008 17:55:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <200809101658.06935.elendil@planet.nl> <20080910152917.634a03fc@the-village.bc.nu>
In-Reply-To: <20080910152917.634a03fc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101755.19927.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2008 15:55:20.0353 (UTC) FILETIME=[A0914110:01C9135D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008, Alan Cox wrote:
> On Wed, 10 Sep 2008 16:58:06 +0200 Frans Pop <elendil@planet.nl> wrote:
> > After resuming my system today I noticed that the system time was
> > off. By 16 years...
>
> Must be the large hadron collider.

Probably. Especially as the sun is rather inactive ATM.

> > $ date
> > Wed Jul  3 23:09:23 CEST 2024
>
> Is this repeatable ?

This wasn't the first suspend I've done today and I'd not seen it before.
I'll follow up if it does repeat, but I thought it was strange and 
potentially important enough to at least report this occurrence. It might 
ring a bell with someone.
