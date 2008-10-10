Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYJJPxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYJJPxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbYJJPxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:53:14 -0400
Received: from kroah.org ([198.145.64.141]:53774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757425AbYJJPxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:53:14 -0400
Date: Fri, 10 Oct 2008 08:48:52 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Smith <dsmith@redhat.com>, Roland McGrath <roland@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [PATCH] Marker depmod fix core kernel list
Message-ID: <20081010154852.GA20231@kroah.com>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org> <20081003195436.GA13506@Krystal> <20081004152456.GB23398@mit.edu> <20081006040820.GB26148@kroah.com> <20081010093901.GC13996@elte.hu> <20081010093942.GA15086@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010093942.GA15086@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 11:39:42AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > the patch went upstream without a Cc: <stable@kernel.org> tag, so i'm 
> > sending it here as a backport request. The upstream commit is below.
> 
> ah, ignore me - we broke it in .27-rc1 so .26 and earlier is not 
> affected.

Gladly ignored :)

thanks,

greg k-h
