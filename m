Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbXG1Gpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbXG1Gpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbXG1Gpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:45:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbXG1Gpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:45:34 -0400
Date: Fri, 27 Jul 2007 23:45:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm/sparse.c:482: error: implicit declaration of function
 =?UTF-8?B?4oCYc3BhcnNlX2Vhcmx5X3VzZW1hcF9hbGxvY+KAmQ==?=
Message-Id: <20070727234526.f4a3ad83.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0707272314y3b4066drda32661642f08eda@mail.gmail.com>
References: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
	<a44ae5cd0707272314y3b4066drda32661642f08eda@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 23:14:04 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> On 7/27/07, Miles Lane <miles.lane@gmail.com> wrote:
> > Do you need my .config file?
> >
> >   CC      mm/sparse.o
> > mm/sparse.c: In function 'sparse_init':
> > mm/sparse.c:482: error: implicit declaration of function
> > 'sparse_early_usemap_alloc'
> > mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> > make[1]: *** [mm/sparse.o] Error 1
> >
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.23-rc1-mm1
> # Fri Jul 27 22:54:36 2007

Whatever it is was gone away in the current -mm lineup so I
guess one of the post-2.6.23-rc1-mm1 patches I merged fixed it.
