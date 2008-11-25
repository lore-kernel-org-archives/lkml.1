Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbYKYXon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYKYXon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYKYXof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:44:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbYKYXoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:44:34 -0500
Date: Tue, 25 Nov 2008 15:43:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: yinghan@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       menage@google.com, rientjes@google.com, rohitseth@google.com
Subject: Re: [PATCH][V4]Make get_user_pages interruptible
Message-Id: <20081125154354.001a6ae0.akpm@linux-foundation.org>
In-Reply-To: <1227605300.1566.17.camel@penberg-laptop>
References: <604427e00811241521t3e75650ft48bc60cdfb16df0e@mail.gmail.com>
	<1227605300.1566.17.camel@penberg-laptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 11:28:20 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> ___You might want to add an explanation why we check both 'tsk' and
> 'current' in either in the patch description or as a comment, though. Or
> just add a link to the mailing list archives in the description or
> something.

As a code comment, I'd suggest.

> > Signed-off-by:	Paul Menage <menage@google.com>
> > Singed-off-by:	Ying Han <yinghan@google.com>
>   ^^^^^^
> 
> I'm sure you have a beautiful singing voice but from legal point of
> view, it's probably better to just sign it off. ;-)

That's my favorite typo.
