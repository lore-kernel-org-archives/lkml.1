Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbXHBPJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbXHBPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXHBPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:09:08 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59427 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbXHBPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:09:07 -0400
Date: Thu, 2 Aug 2007 11:09:06 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Woke up to a crashed kernet this morning - nVidia is crap
Message-ID: <20070802150906.GC14084@csclub.uwaterloo.ca>
References: <6bffcb0e0708020728x5751fc76pad5deadce3a21a5b@mail.gmail.com> <898083.40014.qm@web52507.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <898083.40014.qm@web52507.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 07:46:49AM -0700, Marc Perkel wrote:
> OK - so the driver I downloaded from nVidia to fix
> their problem I was having with the video installed
> drivers for everything? I'm really getting to dislike
> nVidia.

It installs a kernel module just for the video card.  Nothing else.  But
being a kernel module means any bugs in it could mess up other stuff in
the kernel.

Now if you can reproduce the crash without the nvidia module, then you
have something to report.  For what it is worth, it seems the nvidia
module has very rarely been the cause of crashes, but since you can
never tell, it is best to reproduce the problem without it to be sure.

--
Len Sorensen
