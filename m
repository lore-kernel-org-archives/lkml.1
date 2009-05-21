Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZEUQuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZEUQuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZEUQuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:50:04 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:48627 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbZEUQuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:50:03 -0400
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090521142026.GA5566@geggus.net>
References: <20090521142026.GA5566@geggus.net>
Content-Type: text/plain
Date: Thu, 21 May 2009 12:49:59 -0400
Message-Id: <1242924599.6687.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 2 msgs/h 1 sum rcpts/h 3 sum msgs/h 1 total rcpts 392 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: DD0D08ECB1006E8F3B007333F1C048E1DE66EA03
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 298 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 16:20 +0200, Sven Geggus wrote:
> Hello,
> 
> starting from Kernel 2.6.29.x (x=0 to 4) I get hundreds of the
> following messages on my NFS-Server:
> 
> reconnect_path: npd != pd
> 
> The system works fine using 2.6.27.x
> 
> Unfortunatele the message is not harmless, because the client gets stale
> NFS handles which is especially troublesome on diskless Workstations
> using NFS root.
> 
> Regards
> 
> Sven
> 
> P.S.: The userland in use is Debian stable (lenny).

I can't find any such error message in the kernel. Is this the userland
NFS server? If so, then this is the wrong list...

Trond

