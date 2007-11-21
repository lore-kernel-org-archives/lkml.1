Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbXKURXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbXKURXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXKURW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:22:56 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45930 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbXKURWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:22:55 -0500
Date: Wed, 21 Nov 2007 12:22:54 -0500
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       goodmenkernel@gmail.com
Subject: Re: Is there any word about this bug in gcc ?
Message-ID: <20071121172254.GA1299@csclub.uwaterloo.ca>
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au> <4742831F.9040408@zytor.com> <877ikc1v3a.fsf@hades.wkstn.nix> <47442FA9.6020600@gmail.com> <47445A79.7020902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47445A79.7020902@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 09:19:05PM +0500, Alexander E. Patrakov wrote:
> And on IRC, they explained that it is a piece of code that never gets 
> called. So not a hit.

It's still a hit.  If the code is never called it should not be there in
the first place.

--
Len Sorensen
