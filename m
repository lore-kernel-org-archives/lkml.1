Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXKOTk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXKOTk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760281AbXKOTkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:40:45 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:1442 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXKOTko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:40:44 -0500
X-Server-Uuid: A6C4E0AE-A7F0-449F-BAE7-7FA0D737AC76
Subject: Re: tg3: strange errors and non-working-ness
From: "Michael Chan" <mchan@broadcom.com>
To: "Jon Nelson" <jnelson@jamponi.net>
cc: "Jarek Poplawski" <jarkao2@o2.pl>, "netdev" <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <cccedfc60711151117v70b285fbl79bbc92ced176d54@mail.gmail.com>
References: <20071115094728.GB2366@ff.dom.local>
 <1195154603.6360.9.camel@dell>
 <cccedfc60711151117v70b285fbl79bbc92ced176d54@mail.gmail.com>
Date: Thu, 15 Nov 2007 12:23:20 -0800
Message-ID: <1195158200.6360.17.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6B227F273BS980874-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-15 at 13:17 -0600, Jon Nelson wrote:

> Is this what you mean? I pulled this from the quoted text:
> 
> Nov 10 22:45:52 frank kernel: NETDEV WATCHDOG: eth0: transmit timed out
> 

Right.  This explains the reset at 22:45:52, but not the earlier reset
at 22:24:40.  Link never came up after that earlier reset.

Is this a new problem introduced by a new driver?  I notice you are
using tg3 3.65.  Have you used newer versions or older versions?

