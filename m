Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYLGX4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYLGX4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 18:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYLGX4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 18:56:15 -0500
Received: from vps1.tull.net ([66.180.172.116]:56783 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750919AbYLGX4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 18:56:14 -0500
Date: Mon, 8 Dec 2008 10:56:10 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: David Miller <davem@davemloft.net>
Cc: den@openvz.org, xemul@openvz.org, yoshfuji@linux-ipv6.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in wext.c
Message-ID: <20081207235610.GC27057@mail.local.tull.net>
References: <20081205030809.32393.55419.stgit@marcab.local.tull.net> <20081206.235655.61233030.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206.235655.61233030.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 11:56:55PM -0800, David Miller wrote:
> From: Nick Andrew <nick@nick-andrew.net>
> Date: Fri, 05 Dec 2008 14:08:09 +1100
> 
> > Fix incorrect use of loose in wext.c
> > 
> > It should be 'lose', not 'loose'.
> > 
> > Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> 
> Applied to net-next-2.6, thanks Nick.

Thanks for your help.

> BTW, your original posting of this patch didn't make it to the mailing
> lists because there were people's names on the CC: list which had a
> "." character in them, and in such cases these names must be fully
> surrounded by double quotes, otherwise it is an SMTP syntax error.
> 
> Please be mindful of this in the future.

Yes, it looks like "stg mail" doesn't do address quoting on the names
which were added by grabbing Signed-off-by: lines. LKML rejected the
post but the other recipients probably received it, meaning they end
up with two copies (sorry folks). I'll be watching out for that in
future patches.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
