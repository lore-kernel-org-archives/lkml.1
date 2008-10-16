Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYJPCLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYJPCLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYJPCKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:10:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYJPCKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:10:52 -0400
Message-Id: <200810160210.m9G29kst029508@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [RFC] Kernel version numbering scheme change
Date: Wed, 15 Oct 2008 19:10:13 -0700
Importance: normal
X-Priority: 3
To: David Sanders <linux@sandersweb.net>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That would seem to combine the worst of both...

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: David Sanders <linux@sandersweb.net>
Sent: Wednesday, October 15, 2008 18:51
To: H. Peter Anvin <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>; Linus Torvalds <torvalds@linux-foundation.org>; linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change

On Wednesday 15 October 2008 09:03:37 pm H. Peter Anvin wrote:
> Greg KH wrote:
> > Yes, we can handle the major/minor macros in the kernel to provide a
> > compatible number so that automated scripts will not break, that's not a
> > big deal.
> >
> Personally I find that having a simple counter is kind of nice, simply
> because one can talk about 27, 28, 29, ... and actually be able to rely
> on it being stable.

How  about 2008.27.0, 2008.27.1, 2008.28.0, ...
David

