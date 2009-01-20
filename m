Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZATOSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZATOSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762728AbZATORf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:17:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:19217 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762714AbZATORd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R5Bj3pvcQQ4mfl+EtTSG7vm7MDNmuJ5I4nvDC3+2qNc4AiP9GF+mVwf+tB+Vd2Io8o
         5W96OwGgJwOeHuL6OdYa2DCz4e4DeGcbARPDWp4jUJ31Xx+bU8833PBpRWmKRPtyP+B8
         Ym+FPfCvu2TyBmMR8TxstGIyDc+U30/7w/8i0=
Date: Tue, 20 Jan 2009 17:17:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: davem@davemloft.net, jchapman@katalix.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, devel@openvz.org, xemul@openvz.org
Subject: Re: [PATCH 0/5] ppp,pppoe,pppol2tp -- introduce namespace
	functionality v2
Message-ID: <20090120141728.GA14560@localhost>
References: <4975dc11.0c07560a.7a93.ffff9782@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975dc11.0c07560a.7a93.ffff9782@mx.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Jan 20, 2009 at 05:05:10PM +0300]
| Hi, here is a series of patches in hope to bring
| net-namespace functionality for PPP, PPPoE, PPPoL2TP
| protocols.
| 
| I've tested plain PPP virtualization and it worked
| for me. Quite may thanks to James Chapman who
| was testing PPPoL2TP for me, thanks a lot again
| James!
| 
| Please review and test if possible. I do really
| appreciate _any_ kind of feedback. Thanks!
| 
| I didn't put Ack I got on previous series since it's
| a bit new (though PPPoE didn't changed but anyway)
| 
| The patches are on top of net-2.6 commit
| 
| commit f4895b8bc83a22a36446c4aee277e1750fcc6a18
| Author: Inaky Perez-Gonzalez <inaky@linux.intel.com>
| Date:   Mon Jan 19 13:19:30 2009 +0000
| 
|     wimax/i2400m: error paths that need to free an skb should use kfree_skb()
| 
| 	Cyrill
| -- 
| 

Ugh, sorry, quilt again screwed my post-date :(
It seems I defenitely has to switch to git.
		- Cyrill -
