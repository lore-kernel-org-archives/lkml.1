Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZL3O7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZL3O7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 09:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZL3O7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 09:59:16 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:53568 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752872AbZL3O7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 09:59:15 -0500
X-Greylist: delayed 75548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Dec 2009 09:59:15 EST
Date: Wed, 30 Dec 2009 09:59:11 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Regression, bisected] Receive failure in et131x.
Message-ID: <20091230145911.GA12675@emergent.ellipticsemi.com>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20091229180005.GA23030@emergent.ellipticsemi.com>
 <20091229210822.2a6a5f80@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091229210822.2a6a5f80@lxorguk.ukuu.org.uk>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:08 Tue 29 Dec     , Alan Cox wrote:
> Thanks - I'll beat that one over the head Jan 2nd and get it back into
> order.

Great, thanks a lot.

> What setup are you using and at what speed ?

I assume by "setup" you are referring to the network configuration.  I'd
copy the ifconfig output for you, but I'm not at the machine right now.
However, it's pretty plain (defaults everywhere -- 1500 byte mtu, one
ipv4 address).  I am using gigabit.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
