Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZDUJVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZDUJVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZDUJVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:21:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44631 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZDUJVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:21:35 -0400
Date: Tue, 21 Apr 2009 11:21:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/2] fs/compat_ioctl: fix build when !BLOCK
Message-ID: <20090421092133.GG4593@kernel.dk>
References: <1240215264-8096-1-git-send-email-a.beregalov@gmail.com> <20090421073234.GB4593@kernel.dk> <a4423d670904210134i2aa1b6b9xf9d38792b7302044@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904210134i2aa1b6b9xf9d38792b7302044@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21 2009, Alexander Beregalov wrote:
> 2009/4/21 Jens Axboe <jens.axboe@oracle.com>:
> > On Mon, Apr 20 2009, Alexander Beregalov wrote:
> >> From: alexb <alexb@localhost.(none)>
> >>
> >> In file included from fs/compat_ioctl.c:61:
> >> include/linux/loop.h:59: error: field 'lo_bio_list' has incomplete type
> >>
> >> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> >
> > Thanks, applied.
> 
> Hi Jens
> 
> Al has already sent it to Linus.

Oh, it's not in current -git. But it's not a problem, I notice those
kind of things when preparing the push.

-- 
Jens Axboe

