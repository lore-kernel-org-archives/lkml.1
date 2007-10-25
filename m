Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXJYAj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXJYAj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 20:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXJYAjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 20:39:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50079 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXJYAjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 20:39:19 -0400
Date: Thu, 25 Oct 2007 09:41:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [2.6 patch] drivers/base/node.c: cleanups
Message-Id: <20071025094136.021168ea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0710240948120.26032@schroedinger.engr.sgi.com>
References: <20071024162453.GQ30533@stusta.de>
	<Pine.LNX.4.64.0710240948120.26032@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 09:52:56 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 24 Oct 2007, Adrian Bunk wrote:
> 
> > This patch contains the following cleanups:
> > - make the following needlessly globalcode static:
> >   - register_node()
> >   - node_state_attr[]
> > - #if 0 the following unused global functions:
> >   - unregister_node()
> >   - unregister_one_node()
> 
> These may beneeded by the memory hotplug folks. Better leave them 
> alone.
> 
Yes, please leave them for a while...

Thanks,
-Kame

Thank you >> Christoph-san.

