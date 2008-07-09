Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYGIVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYGIVOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYGIVN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:13:58 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:12707
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293AbYGIVN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:13:57 -0400
X-Trace: 109189903/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8AAPfGdEjDiV6i/2dsb2JhbAAIsVY
X-IronPort-AV: E=Sophos;i="4.30,333,1212361200"; 
   d="scan'208";a="109189903"
X-IP-Direction: IN
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
From: ian <spyro@f2s.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080709210314.GF26734@flint.arm.linux.org.uk>
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <1215603916.3295.57.camel@wirenth>
	 <bc64b4640807090452vc923216gfb14bb2c5974a61@mail.gmail.com>
	 <20080709210314.GF26734@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 22:13:54 +0100
Message-Id: <1215638034.3295.116.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 22:03 +0100, Russell King - ARM Linux wrote:
> 
> Given that, and where we are (there's maybe two of *my* days left
> until the merge window opens) I'm *very* tempted to drop the MFD
> support out of my tree for this merge window - which basically means
> removing 5127/1, 5128/1 and 5129/1.

Please dont.

The code thats in already is perfectly ok for what its doing.

The discussion now is on ways to improve MFD for new devices, and
somewhat tangential. All the improvements can wait until after 2.6.26.



