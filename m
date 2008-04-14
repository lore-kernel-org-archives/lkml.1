Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYDNQSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYDNQSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbYDNQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:18:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:2216 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbYDNQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=l3w4k+D7f9SudlD8TQmXwi0IraTU0REOJWzsJV5S2jgyqwQbKJHaVZPI3KglXoZed25TQqxU7ber9Qjbi7LmZxYgMCfthLpJ7B1JRU+WhSG/ww7lmkepNW4d4wybJL7P2TblypLW1v/3TOolGr7qzEOfLHCsFKrpWAM6e57QAYg=
Message-ID: <84144f020804140918h7de939f1x59b7b9f17f8e7749@mail.gmail.com>
Date: Mon, 14 Apr 2008 19:18:35 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       clameter@sgi.com
In-Reply-To: <20080413135344.60dc2e05.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	 <20080413204422.GA5136@martell.zuzino.mipt.ru>
	 <20080413135344.60dc2e05.akpm@linux-foundation.org>
X-Google-Sender-Auth: 4b418a8a473973e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 11:53 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  Yes, I don't think the sub changes are ready for prime-time.

Indeed. I now dropped the SLUB defragmentation patches from the
'for-mm' branch so Andrew can you please pull the new branch to -mm?
