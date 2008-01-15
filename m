Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYAOU00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYAOU00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYAOU0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:26:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:64077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYAOU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:26:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h3e/pk7lYjHpwlCLZTK7+HiBiqSbnDxN4ILr3WxoRjeJ8TH1ZAfHceeqiaj5V+vUL1OccAraz374pZmTQRw0Hcbjn+9UKAqFTD/yWevD8/xDE8ZwV2YW54yxPSBtO26iEQhKihz0c0UIAkAqpfZJugRr1zVy1ZhNN5l3FUel7vw=
Date: Tue, 15 Jan 2008 21:29:05 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network
	packets
Message-ID: <20080115202905.GA2680@ami.dom.local>
References: <20080115071950.GA1696@ff.dom.local> <478CC76B.1020804@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CC76B.1020804@nortel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 08:47:07AM -0600, Chris Friesen wrote:
> Jarek Poplawski wrote:
>
>> IMHO, checking this with a current stable, which probably you are going
>> to do some day, anyway, should be 100% acceptable: giving some input to
>> netdev, while still working for yourself.
>
> While I would love to do this, it's not that simple.

...Hmm... As a matter of fact, I expected you'd treat my point less
literally... Of course, I know it could be sometimes very hard to get
something working even after upgrading one version, let alone several
at once.

So, it was more a rhetorical trick (sorry!) to suggest, that such a
business model of being always late with kernels might be quite
practical and reasonable for many companies, but looks like the
worst possible development model for Linux.

On the other hand, it seems there are not so much, nor expensive
changes needed (a bit more perspective thinking?) to make everybody
happy...

Jarek P.
