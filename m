Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXD0XrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXD0XrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbXD0XrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:47:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455AbXD0XrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:47:15 -0400
Date: Fri, 27 Apr 2007 16:46:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-Id: <20070427164629.fde8ffca.akpm@linux-foundation.org>
In-Reply-To: <20070426232902.GA10423@zarina>
References: <20070426232902.GA10423@zarina>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 03:29:02 +0400
Anton Vorontsov <cbou@mail.ru> wrote:

> You can get it using "git clone --reference linux-2.6 \
> git://git.infradead.org/users/cbou/battery2-2.6.git" command.

I added this to the -mm lineup.

Welcome to git.  This means that nobody looks at your code any more and you
get free rein to experiment with interesting innovations in VFS, MM and
security in the mainline kernel (well, not really - Linus does squint at
the diffstat).

But we do have a general problem that code which travels the
developer->git->mainline route is not getting sufficient review.  Please be
aware of this, and be as pushy as you like in sending your changes out to
mailing lists (including linux-kernel) to get them reviewed.

If you don't think they have received adequate review then send them again,
and shout at people - we'd all admire that.

Thanks.
