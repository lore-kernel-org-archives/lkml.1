Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYENWGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYENWGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYENWGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:06:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46063 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYENWGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:06:23 -0400
Message-ID: <482B6259.3070507@garzik.org>
Date: Wed, 14 May 2008 18:06:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Jamie Lokier <jamie@shareable.org>,
       Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <482B378C.5070807@garzik.org> <20080514193843.GB10165@2ka.mipt.ru> <20080514215704.GE23758@shareable.org>
In-Reply-To: <20080514215704.GE23758@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> With the right topology and hardware, you can get _faster_ than single
> node performance with as many nodes as you like

This is the core reason why I am so interested in distributed storage... 
  a single storage device is usually slower than network wire speed. 
Multiple nodes helps remove that limitation and max out the network.

I want to be able to stream data _faster_ than a single hard drive can 
handle :)

	Jeff



