Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZCDPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZCDPh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZCDPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:37:10 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:33084 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZCDPhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:37:08 -0500
Message-ID: <49AEA01F.8050906@hp.com>
Date: Wed, 04 Mar 2009 10:37:03 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: arvidjaar@mail.ru, vladislav.yasevich@hp.com, chuck.lever@oracle.com,
       tytso@mit.edu, Valdis.Kletnieks@vt.edu, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com
Subject: Re: [PATCH 1/2] IPv6: add "disable" module parameter support to ipv6.ko
References: <49ADE95F.8060607@hp.com> <20090304.032145.115092643.davem@davemloft.net>
In-Reply-To: <20090304.032145.115092643.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Applied, but you have to do something about your email client
> and what it does to patches Brian.
> 
> Every line that starts with a single space then TABs was
> replaced with two space characters then the TABs.  Long
> lines were also chopped up.

Sorry, I'll blame it on git-imap-send/tbird :) - I just know how people hate 
attachments, I can play with the settings again.  I'll send it to myself first 
next time and see what gets corrupted, thanks for fixing it up.

I wish we didn't have to do this hack though...

-Brian
