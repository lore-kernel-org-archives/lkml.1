Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYKQGC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYKQGC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYKQGCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:02:47 -0500
Received: from kroah.org ([198.145.64.141]:58094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751357AbYKQGCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:02:47 -0500
Date: Sun, 16 Nov 2008 21:56:03 -0800
From: Greg KH <greg@kroah.com>
To: Steve French <smfrench@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Re: third patch
Message-ID: <20081117055603.GA1381@kroah.com>
References: <20081114185039.1f3af842@tleilax.poochiereds.net> <524f69650811141609n63f3631bn6493e2be76b1bed6@mail.gmail.com> <20081115063641.26003498@tleilax.poochiereds.net> <524f69650811161918i738ba50frd87666a58640b76f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650811161918i738ba50frd87666a58640b76f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 09:18:43PM -0600, Steve French wrote:
> Jeff and I have worked on a series of patches to fix the oopses,
> memory corruption and mount failures due to races in various linked
> list handling relating to socket, session and tree connection when
> using the reproducer detailed here:
> 
> https://bugzilla.samba.org/show_bug.cgi?id=5720
> 
> The fix series is now merged into cifs-2.6.git

Are these patches going to be sent to Linus for the 2.6.28 release?
Should they be also added to the 2.6.27-stable tree when they get to
Linus's tree?  If so, what are their git commit ids?

thanks,

greg k-h
