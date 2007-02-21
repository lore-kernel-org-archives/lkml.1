Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbXBULeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbXBULeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXBULeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:34:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60399 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbXBULeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:34:13 -0500
Date: Wed, 21 Feb 2007 12:34:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: bert hubert <bert.hubert@netherlabs.nl>, Andi Kleen <andi@firstfloor.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking UDPv4 recvfrom() taking 4usec @ 3GHz?
Message-ID: <20070221113409.GA28479@one.firstfloor.org>
References: <20070219231447.GA4400@outpost.ds9a.nl> <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl> <20070220164124.GA24930@2ka.mipt.ru> <20070220170232.GA4730@outpost.ds9a.nl> <20070220171120.GD24930@2ka.mipt.ru> <20070221110634.GA30394@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221110634.GA30394@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:06:34PM +0300, Evgeniy Polyakov wrote:
> Here is data for 50 bytes reading for essentially idle machine 
> (core duo 2.4 ghz):
> 
> delta for syscall: 3326961404-3326969261: 7857 cycles = 3.273750 us

Can you oprofile it too?

-Andi
