Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYIWL7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYIWL7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYIWL7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:59:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43137 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbYIWL7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:59:23 -0400
Date: Tue, 23 Sep 2008 13:59:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Remi Machet <rmachet@slac.stanford.edu>,
       Linux Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: SPLICE_F_MOVE
Message-ID: <20080923115920.GZ26460@kernel.dk>
References: <1222125940.1313.83.camel@pcds-ts102.slac.stanford.edu> <517f3f820809230456r66fa68dcw2362b214ca1de5f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517f3f820809230456r66fa68dcw2362b214ca1de5f6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23 2008, Michael Kerrisk wrote:
> [CC+=Jens, who should be able to help]
> 
> On 9/23/08, Remi Machet <rmachet@slac.stanford.edu> wrote:
> > Hi,
> >
> >  Does anyone know if SPLICE_F_MOVE is obsolete or still in use ?
> >
> >  The documentation says that the flag should be used to tell splice not
> >  to copy the data when moving data to/from a pipe, but I cannot find
> >  anywhere in the kernel where this flag is being used or checked for.

It's not currently used, it got yanked and is waiting for a replacement
implementation.

-- 
Jens Axboe

