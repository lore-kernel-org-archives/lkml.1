Return-Path: <linux-kernel-owner+w=401wt.eu-S965659AbXA3SAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965659AbXA3SAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXA3SAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:00:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:11012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965659AbXA3SAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GW20udJWEnxhUka7tIr4mjvSZayIWyejwNCZ/Q+yop0DfJcSm6Dq79Bnl1czStdwlsJgR4HDY4+U0ll0yTaQHz5l1utH8MqdbK6HXHNFUbQx9RGsQEMLvGevE6+jnT7UCA9Yl/+AiB/cvNHHi/aYNmS8OE0LtLV8S72npeFyTSw=
Date: Tue, 30 Jan 2007 21:00:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange XServer (KDE) log out on 2.6.20-rc6 !!
Message-ID: <20070130180009.GA5551@martell.zuzino.mipt.ru>
References: <8355959a0701300731i4b5b1f77t527deeb8fc5ad5fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8355959a0701300731i4b5b1f77t527deeb8fc5ad5fd@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 09:01:20PM +0530, Sunil Naidu wrote:
> I was working on this test machine with 2.6.20-rc6. There was a
> strange X log out (KDE 3.5.x). Three applications were running:
> BitTorrent client, Firefox 1.5.8, and KWrite.
> 
> Suddenly, there was a log out from my work space (blank-blink for 3-4
> seconds duration). Then, KDE log in screen appeared. When I logged in
> back, those applications were gone!!
> 
> I would like to investigate this issue - whether it's a X bug or
> something to do with kernel?. I am not running the Firewall & SELinux
> (but, connected to internet).
> 
> Any inputs for this pl? This maybe OT for LKML...not sure :(

Have you pressed Ctrl+Alt+Backspace (by mistake)?

