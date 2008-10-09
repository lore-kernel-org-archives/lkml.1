Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYJIV3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYJIV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYJIV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:29:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbYJIV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:29:25 -0400
Date: Thu, 9 Oct 2008 14:27:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
In-Reply-To: <20081009212052.GS19428@kernel.dk>
Message-ID: <alpine.LFD.2.00.0810091427160.3210@nehalem.linux-foundation.org>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org> <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu>
 <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org> <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org> <20081009212052.GS19428@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Oct 2008, Jens Axboe wrote:
> 
> A little late I see, but FWIW I agree.

Well, not too late, since I hadn't pushed it out. I amended the commit to 
have an acked-by from you.

And now it _is_ pushed out.

		Linus
