Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYDNDJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYDNDJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 23:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYDNDJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 23:09:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44251 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYDNDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 23:09:30 -0400
Date: Mon, 14 Apr 2008 12:13:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080414121358.3f864dba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1207923851.7212.14.camel@haji>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
	<1207910058.7212.1.camel@haji>
	<20080411195738.16e9ef92.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411201724.e820122b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411221714.5f917a72.kamezawa.hiroyu@jp.fujitsu.com>
	<1207923851.7212.14.camel@haji>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 17:24:11 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:
 
> >     The KICKABLE flag is set again when all objects of the slab have been
> >     allocated (Occurs during removal of a slab from the partial lists).
> > 
> >     Reviewed-by: Rik van Riel <riel@redhat.com>
> >     Signed-off-by: Christoph Lameter <clameter@sgi.com>
> >     Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> My bad, sorry. Fixed and pushed out.
> 
Works well. Thank you.
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

-Kame

