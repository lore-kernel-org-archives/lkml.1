Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbXJAWbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbXJAWbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXJAWay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:30:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:4925 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXJAWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gnjWsT0USKdp67BO+gwcQnhW2EvqQxcYfFHqE0cSXphu2gMR5SJozrdJ1GPX85TXxqXine+Bk6xOQBRhbM4+x+eX8yQ35yuyFoYF0L9u405P+9kSK3CIbHD2o9fbrlM53YU+zsBIZOy1iwaoLVOFBJ2jR8wVTKnFGWsrPe/VQnk=
Message-ID: <47017474.4040701@googlemail.com>
Date: Tue, 02 Oct 2007 00:28:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-10-01-04-09.tar.gz uploaded
References: <200710011115.l91BFRvg012762@imap1.linux-foundation.org> <47016AFB.7040307@googlemail.com> <Pine.LNX.4.64.0710012352450.22331@twin.jikos.cz> <47016FEE.6090608@googlemail.com> <Pine.LNX.4.64.0710020015060.22331@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710020015060.22331@twin.jikos.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 2 Oct 2007, Gabriel C wrote:
> 
>>>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-10-01-04-09.tar.gz
>>> There is a 'series' file, which tells you the correct order. If you are 
>>> planning to make any patches on top of mm, you should use quilt for this.
>> Thx for your quick reply  but I cannot find any series file in this tarball.
> 
> $ tar xzvf broken-out-2007-10-01-04-09.tar.gz | grep series | head -1
> series
> 

Hmm .. something is broken with the tarball I have 

$ tar xzvf broken-out-2007-10-01-04-09.tar.gz | grep series | head -1
broken-out/hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch

I'll re download and will figure ,thx again for your help.

Gabriel
