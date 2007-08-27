Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXH0QgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXH0QgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXH0QgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:36:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbXH0QgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:36:11 -0400
Date: Mon, 27 Aug 2007 09:35:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       axboe@kernel.dk
Subject: Re: [RFC] block_device_operations prototype changes
In-Reply-To: <20070827103053.GF21089@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.999.0708270933560.25853@woody.linux-foundation.org>
References: <20070827103053.GF21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Aug 2007, Al Viro wrote:
> 
> I have the beginning of that series done and the rest mapped out in enough
> details to implement it over this week.  If somebody has objections,
> questions or comments - yell.

>From your description, I have no objections - everything sounds good. My 
only concern is how painful the patch ends up being (and a worry about 
whether this will affect a metric truck-load of external modules? That 
said, I can't really see us worrying about those)

			Linus
