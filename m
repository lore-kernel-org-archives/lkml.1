Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZH0VtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZH0VtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZH0VtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:49:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZH0VtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:49:14 -0400
Date: Thu, 27 Aug 2009 14:46:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.H." <warthog9@kernel.org>
Cc: rdunlap@xenotime.net, hidave.darkstar@gmail.com, webmaster@kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, stable@kernel.org
Subject: Re: mm/-next release on kernel.org web page?
Message-Id: <20090827144612.28e9e25f.akpm@linux-foundation.org>
In-Reply-To: <4A96F355.30808@kernel.org>
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
	<20090802095523.e08166e3.rdunlap@xenotime.net>
	<a8e1da0908021908x8216693k7fb31bc5b58d6666@mail.gmail.com>
	<20090802193045.c3f3195c.rdunlap@xenotime.net>
	<4A766F39.7090903@kernel.org>
	<4A95D677.2020807@kernel.org>
	<a8e1da0908270739sbab4821x6ec402a72587a337@mail.gmail.com>
	<20090827124315.0d0f2129.rdunlap@xenotime.net>
	<4A96F355.30808@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 13:57:57 -0700
"J.H." <warthog9@kernel.org> wrote:

> >> Is it possible to add latest mmotm link?
> >> Just link to andrew's broken-out.tar.gz with the stamp name?
> > 
> > Ditto.  Please.
> 
> Problem with mmotm is that Andrew is hosting that out of his public_html 
> directory, which I can only assume means that the tree isn't intended to 
> be consumed by the masses, as official trees are supposed to live under 
> /pub.  If this is not the case then we need to get it moved under 
> /pub/scm & /pub as things on public_html aren't synced out to the 
> front-end machines.  But I will have to defer to Andrew on what 
> direction he wants to take mmotm.
> 

Well, it'd be simple enough to stick it all in a different directory. 
But I need to find a way to shove most of -mm into linux-next, after
which it all becomes a bit moot.

