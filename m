Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXH0RZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXH0RZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXH0RZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:25:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29800 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbXH0RZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:25:13 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was
	Re:	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <46D303A3.1030708@googlemail.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
	 <1188227585.2435.192.camel@dhcp193.mvista.com>
	 <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
	 <1188229197.2435.207.camel@dhcp193.mvista.com>
	 <46D303A3.1030708@googlemail.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 10:17:28 -0700
Message-Id: <1188235048.2435.252.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 19:02 +0200, Michal Piotrowski wrote:

> Indeed, now we need a predefined search "show regressions in 2.6.x" :)
> 
> So the plan is simple:
> - copy all regressions into bugzilla after each release
> - make sure that all regressions reported on lkml after realase hit bugzilla
> - make sure that all regressions in bugzilla are marked as regression

That would be great ;) 

Daniel

