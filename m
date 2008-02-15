Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbYBOAYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbYBOAYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbYBOAYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:24:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51504 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760794AbYBOAYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:24:40 -0500
Date: Fri, 15 Feb 2008 09:24:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Cc: kosaki.motohiro@jp.fujitsu.com, "Paul Jackson" <pj@sgi.com>,
       rientjes@google.com, Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clameter@sgi.com
In-Reply-To: <2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
References: <20080214103541.10943567.pj@sgi.com> <2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
Message-Id: <20080215092014.1C49.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,

> >  > i prefer another name [!relative].
> >
> >  Any suggestions?
> >
> >  I'll give the name some thought myself.
> >  I like good names, and this is the right
> >  time to get this one right.
> 
> 'Relative map' implies a constant offset. What you have there is just
> a map as relmap could be sparse (which, btw, would have been nice to
> have in the example).
> 
> map_bitmap violates your naming convention, bitmap_map isn't all that
> clear, bitmap_remap is taken, and while it is one-to-one and onto, I
> think calling it bitmap_bijection would lose everyone except the
> mathematicians. bitmap_onto? bitmap_map_onto? bitmap_map_bitmap_onto?

Thanks for many idea.
I like bitmap_onto and/or bitmap_map_onto. :)


- kosaki

