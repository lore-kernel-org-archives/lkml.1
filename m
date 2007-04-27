Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXD0Uco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXD0Uco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbXD0Uco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:32:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:31142 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbXD0Ucm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qOVg7nkozJm636vuP193Hz42ECzGOfUli1xf7EdGpVISoDKhG5N92tC6mxX5pHKwrz8zey/xqVYZCNzSrm18oJv4sAP0uqdlbmXocNU86L0xiQt9d5Tcl3689UgxE3I0BMDgdyzMYb05vz2FLBY8kOlaZRJ8BCHSM5ki5m+3rGs=
Message-ID: <46325D15.90005@googlemail.com>
Date: Fri, 27 Apr 2007 22:29:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andreas Dilger <adilger@clusterfs.com>,
       Marat Buharov <marat.buharov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Alex Tomas <alex@clusterfs.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> There was even somebody who did something like that for a PhD thesis, I 
> forget the details (and it apparently died when the thesis was presumably 
> accepted ;).
>
>   


You mean SpadFS[1] right ?

> 			Linus
>   

Gabriel

[1] http://artax.karlin.mff.cuni.cz/~mikulas/spadfs/
