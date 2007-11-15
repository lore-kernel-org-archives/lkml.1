Return-Path: <linux-kernel-owner+w=401wt.eu-S1765305AbXKOTRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765305AbXKOTRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbXKOTRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:17:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:52468 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbXKOTRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:17:13 -0500
Message-ID: <cccedfc60711151117v70b285fbl79bbc92ced176d54@mail.gmail.com>
Date: Thu, 15 Nov 2007 13:17:10 -0600
From: "Jon Nelson" <jnelson@jamponi.net>
To: "Michael Chan" <mchan@broadcom.com>
Subject: Re: tg3: strange errors and non-working-ness
Cc: "Jarek Poplawski" <jarkao2@o2.pl>, netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1195154603.6360.9.camel@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071115094728.GB2366@ff.dom.local> <1195154603.6360.9.camel@dell>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/07, Michael Chan <mchan@broadcom.com> wrote:
> On Thu, 2007-11-15 at 10:47 +0100, Jarek Poplawski wrote:
> > On 13-11-2007 19:57, Jon Nelson wrote:
> > > The best info I've got is this:
>
> It looks like the card is being reset periodically.  Every time the card
> gets reset, you'll see those PM messages in the version of the driver
> you're using.  Do you see NETDEV WATCHDOG message as well in the dmesg
> log?

Is this what you mean? I pulled this from the quoted text:

Nov 10 22:45:52 frank kernel: NETDEV WATCHDOG: eth0: transmit timed out



-- 
Jon
