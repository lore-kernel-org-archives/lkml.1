Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZFKQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZFKQ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZFKQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:26:37 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:54598 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZFKQ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:26:36 -0400
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
	<20090611.042226.28424489.davem@davemloft.net>
	<20090611114911.GL795@n2100.arm.linux.org.uk>
	<20090611.050030.169859977.davem@davemloft.net>
	<20090611123852.GM795@n2100.arm.linux.org.uk>
	<20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
	<20090611131245.GN795@n2100.arm.linux.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 11 Jun 2009 09:26:36 -0700
In-Reply-To: <20090611131245.GN795@n2100.arm.linux.org.uk> (Russell King's message of "Thu\, 11 Jun 2009 14\:12\:45 +0100")
Message-ID: <87my8erb2b.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Thu, Jun 11, 2009 at 01:54:42PM +0100, Alan Cox wrote:
>> Make your tree the core ARM code only, any other patches you don't
>> accept. Aggressively push stuff out to platform code, and if people want
>> to change core code "because our platform is different" make them extract
>> it into the platform layer not carry it in the core bits.
>
> I'm all for giving this a try after this merge window is over.

Speaking as maintainer of one ARM subarch (davinci) and active
contributor to another (OMAP), I would gladly give this a try as well.

Kevin
