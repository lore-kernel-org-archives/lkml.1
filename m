Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZBDTrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZBDTrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZBDTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:47:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:4077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZBDTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:47:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AdHBhWexZNgLq5gNOnOqyxHcvYAfJ4xuVBijGuKBP9uImiBYwIZTiOdit7uHSv5htK
         y5U1TZ2ff6VfrvdOMZYoxcs4dQ/31W5m2xD0nj4ghe0IPqJU5ju4IOSfbmkzhTLzJtoe
         SAFKxFCfMiKpGoIPezup4tOGMR2wG11NzoEvY=
Date: Wed, 4 Feb 2009 20:48:08 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       herbert@gondor.apana.org.au, zbr@ioremap.net, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090204194808.GA2828@ami.dom.local>
References: <20090204081201.GB10445@ioremap.net> <20090204085432.GA21638@1wt.eu> <20090204085907.GA19388@gondor.apana.org.au> <20090204.010146.18100191.davem@davemloft.net> <20090204091217.GA21385@1wt.eu> <ada63jqm2mt.fsf@cisco.com> <20090204192820.GA27867@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204192820.GA27867@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 08:28:20PM +0100, Willy Tarreau wrote:
...
> Now it's useless to speculate on history and I agree with Davem that
> we're wasting our time with this discussion, let's go back to the
> keyboard ;-)

Davem knows everything, so he is ...wrong. This is a very useful
discussion. Go back to the keyboards, please :-)

Jarek P.
