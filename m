Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0AOJnt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050Ab0AOJns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:43:48 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42184 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab0AOJnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:43:46 -0500
Date: Fri, 15 Jan 2010 10:43:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: stefanr@s5r6.in-berlin.de, adi@hexapodia.org, nm127@freemail.hu,
        david.vrabel@csr.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: Changelog quality
In-Reply-To: <20100115.012233.202457727.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de> <20100115.005445.263291449.davem@davemloft.net>
 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want more clear markers around the script so you can skim
> past it more efficiently when reading the commit message, then ask
> for that.

If there were markers that would cause tools to hide some information 
under a +, that would be great.  Sometimes I have simplified a script 
beyond what would really be reusable just to not create an over-large 
changelog.  I hope that the simplified version is at least understandable, 
so that the reader can get an idea of what considerations went into the 
change, but I recall in one case having messed up on that as well, and 
ended up with something that really gave no information whatsoever.

julia
