Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYJPBv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYJPBv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 21:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYJPBvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 21:51:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:11024 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYJPBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:51:51 -0400
From: David Sanders <linux@sandersweb.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Wed, 15 Oct 2008 21:51:42 -0400
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com> <48F692E9.2080008@zytor.com>
In-Reply-To: <48F692E9.2080008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152151.42950.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
