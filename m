Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786Ab0A2Lh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab0A2Lh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728Ab0A2Lh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:37:28 -0500
Received: from mail1.radix.net ([207.192.128.31]:64769 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab0A2Lh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:37:27 -0500
Subject: Re: how do YOU hack the linux kernel ?
From: Andy Walls <awalls@radix.net>
To: Daniel Mack <daniel@caiaq.de>
Cc: Ramagudi Naziir <naziirr@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100129081010.GA30756@buzzloop.caiaq.de>
References: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
	 <20100129081010.GA30756@buzzloop.caiaq.de>
Content-Type: text/plain
Date: Fri, 29 Jan 2010 06:37:01 -0500
Message-Id: <1264765021.3084.9.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 09:10 +0100, Daniel Mack wrote:
> On Tue, Jan 19, 2010 at 02:52:57PM +0200, Ramagudi Naziir wrote:
> > do you use vim ?
> > 
> > If so, how do you open files you want to read/edit ?
> > Assuming you don't remember their exact name/location, you'd need to
> > use something like 'find . -iname '*pattern*'. which is slow.
> > You can also ":tabnew ." and just browse the folders, but that's super slow too.
> 
> Just use ctags to index your tree. Vim can then use this index to
> directly drop you at the definition of a symbol. Works very well.


Yup.  That's what I use.

>  Just
> google around to find tutorials to describe that in detail.

$ man ctags
$ vim
:help tags

for those who don't wish to rely on the Goggle.

Regards,
Andy

> LXR is also a nice help sometimes: http://lxr.linux.no/linux/
> 
> Other than that you might develop a feeling for where to search, so you
> can narrow your 'git grep' to specific places.
> 
> HTH,
> Daniel


