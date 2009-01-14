Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZANKCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZANKCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZANKCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:02:04 -0500
Received: from 1wt.eu ([62.212.114.60]:1470 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZANKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:02:03 -0500
Date: Wed, 14 Jan 2009 11:01:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       zbr@ioremap.net, dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114100118.GA9888@1wt.eu>
References: <20090113.232710.55011568.davem@davemloft.net> <20090114082630.GB16692@gondor.apana.org.au> <20090114085308.GB4234@ff.dom.local> <20090114.012919.117682429.davem@davemloft.net> <20090114095454.GD4234@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114095454.GD4234@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:54:54AM +0000, Jarek Poplawski wrote:
> You are very brave! I'd prefer to wait for at least minimal testing
> by Willy...

Will test, probably this evening.

Thanks guys,
Willy

