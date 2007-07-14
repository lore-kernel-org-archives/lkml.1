Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXGNDpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXGNDpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbXGNDpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:45:38 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:61729 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXGNDph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vu7F6ojNva7V6MEm1dFfmAmtzrxgZv5CYCpUvIawkKT7PZ0neZHaXEE99MC5FAjU9ZScvxxsHAgIe0Pjz4NJyz1rgissJh9Xt23jCX2clPt/sVOwl+9ZB9LZiEdkac7g6xKYMeCou/DN7/JLaPqQ2yj8ialxxytzez6Hvx6HFf0=
Message-ID: <d3dac270707132045n16918eb2s9f61684cbb030267@mail.gmail.com>
Date: Fri, 13 Jul 2007 20:45:36 -0700
From: "Max Alekseyev" <maxale@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: 2.6.22 booting hangs after "INIT: version 2.86 booting"
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070714013458.GC3565@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d3dac270707111413j42ac7a0eif032636a9018df66@mail.gmail.com>
	 <d3dac270707111831v508e7c56w966df5bc2e7f855e@mail.gmail.com>
	 <20070714013458.GC3565@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Wed, Jul 11, 2007 at 06:31:10PM -0700, Max Alekseyev wrote:
> > It happened that this weird behavior was caused by gcc-4.2 compiler.
> > After recompiling the kernel with gcc-4.1 all troubles have gone.
>
> Were you using the known-bad 4.2-20070707-1 package from Debian unstable
> or a different compiler?

Your guess is correct. It was Debian 4.2-20070707-1 package.

Regards,
Max
