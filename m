Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXFKGJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXFKGJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbXFKGJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:09:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbXFKGJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:09:20 -0400
Date: Sun, 10 Jun 2007 23:09:06 -0700
From: Greg KH <gregkh@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>, linux-kernel@vger.kernel.org,
       m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070611060906.GC914@suse.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <20070611115557.4340f45e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611115557.4340f45e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 11:55:57AM +0900, KAMEZAWA Hiroyuki wrote:
> 
> Hi, thank you for your work. I was impressed.
> 
> BTW, how about adding following lines (both in Japanese and English) ?
> ==
> This is translated "HOWTO" documentation. Original "HOWTO" is maintaind by 
> Greg Kroah-Hartman <greg@kroah.com> and linux kernal mailing list.
> And this one is maintained by Tsugikazu Shibata <tsugikazu.shibata@jp.nec.com>
> and JF Projet <www.linux.or.jp/JF>. Because original HOWTO documentation itself
> is being updated day and night, this file may contain old sentences. Please contact
> JF project if you find problems in translation.
> 
> It is guaranteed that this file is just a translation and doesn't contains any
> additional information, sentences. If you want to update "HOWTO", please update
> English version first. Don't fork from original if you update this file.
> 
> Last Updated: 2007/06/04  Version: 2.6.21
> ==
> 
> not worth writing ?

That sounds fine with me, and would be good to have.  I also have no
problem also CC:ing anyone who wants to translate this file with patches
that happen to modify the originals.  That way they can easily keep up
with the minor number of changes that happen over time.

thanks,

greg k-h
