Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbYBMPo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbYBMPo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYBMPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:44:20 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:43326 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYBMPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:44:19 -0500
Date: Wed, 13 Feb 2008 18:44:22 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: =?iso-8859-1?Q?Ra=FAl?= Porcel <armin76@gentoo.org>,
       linux-kernel@vger.kernel.org, rth@twiddle.net
Subject: Re: [ALPHA] ES40 fails to boot with >=kernel 2.6.23
Message-ID: <20080213154422.GA32748@jurassic.park.msu.ru>
References: <47B0858A.4090409@gentoo.org> <200802131622.58778.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802131622.58778.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 04:22:58PM +1100, Nick Piggin wrote:
> On Tuesday 12 February 2008 04:27, Raúl Porcel wrote:
> > We have a Compaq AlphaServer ES40 and since 2.6.23 it won't boot. I'm
> > attaching the console log and the kernel config.

Looks like your 'aboot' is outdated - see http://lkml.org/lkml/2007/8/14/259

I think all distros have an updated aboot package now.

> Thanks for reporting. I'm not an alpha person, but I have
> cc'ed them in case they missed this.

Thanks, I indeed missed that.

Ivan.
