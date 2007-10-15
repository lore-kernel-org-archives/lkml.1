Return-Path: <linux-kernel-owner+w=401wt.eu-S1765734AbXJOUoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765734AbXJOUoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXJOUny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:43:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758259AbXJOUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:43:53 -0400
Date: Mon, 15 Oct 2007 13:43:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.24-rc0
In-Reply-To: <d120d5000710151328k6f413b76i21809691d9a18fe8@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710151341540.6887@woody.linux-foundation.org>
References: <200710131614.35356.dmitry.torokhov@gmail.com>
 <d120d5000710151328k6f413b76i21809691d9a18fe8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Dmitry Torokhov wrote:
> 
> *ping*

Thanks, pulled and pushed out.

Can you check that applesmc looks sane after the merge conflict? The 
conflict itself looked pretty trivial, and it compiles for me, but I'd 
still like somebody who knows those things to double-check..

		Linus
