Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZLUL3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZLUL3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZLUL3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:29:43 -0500
Received: from ozlabs.org ([203.10.76.45]:60681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZLUL3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:29:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/3] vhost: fix use_mm usage
Date: Mon, 21 Dec 2009 21:59:39 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20091220171608.GA31713@redhat.com>
In-Reply-To: <20091220171608.GA31713@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212159.39198.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 03:46:08 am Michael S. Tsirkin wrote:
> This patchset fixes an issue, pointed out by Al Viro, in how vhost net
> calls use_mm, Works fine for me, and it's pretty straightforward.  If no
> one sees any issues with it, this will be a good candidate for 2.6.33
> (assuming vhost net itself gets pulled :( ).

No, Linus didn't respond to either pull request.  Either he considers it a
new driver and hence not in a hurry to enter merge window, or there's some
other issue.

I've taken these fixes too, meanwhile.

Thanks,
Rusty.
