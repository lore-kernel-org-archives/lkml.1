Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYH0Q0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYH0Q0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYH0QZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:25:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50266 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbYH0QZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:25:04 -0400
Date: Wed, 27 Aug 2008 18:27:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rick Jones <rick.jones2@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080827162735.GW26610@one.firstfloor.org>
References: <200808220457.40892.denys@visp.net.lb> <20080826201406.GA24827@2ka.mipt.ru> <48B46B48.7030609@cosmosbay.com> <20080826205158.GA15266@2ka.mipt.ru> <87vdxmr53f.fsf@basil.nowhere.org> <48B57BD3.5050206@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B57BD3.5050206@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Those banks really want to crank down on latency - to the point they 
> start disabling interrupt coalescing.  I bet they'd toss anything out 
> they could to shave another microsecond.

This change would actually likely lower their latency.

-Andi
