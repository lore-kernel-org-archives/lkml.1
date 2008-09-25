Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYIYOAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYIYOAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYIYOAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:00:00 -0400
Received: from [198.145.64.141] ([198.145.64.141]:35866 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752363AbYIYN77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:59:59 -0400
Date: Thu, 25 Sep 2008 06:54:03 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080925135403.GA7491@kroah.com>
References: <20080925125423.GB6750@kroah.com> <4SWEQQNy.1222350499.8369530.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4SWEQQNy.1222350499.8369530.pluto@agmk.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 03:48:19PM +0200, Paweł Sikora wrote:
> 25/9/2008, "Greg KH" <greg@kroah.com> napisał/a:
> 
> >Are there any other out-of-tree modules that I need to be aware of to
> >help integrate?
> 
> could you look at these:
> - http://www.tahoe.pl/eng/patch.php

This looks almost sane, I'll suck it in and contact the author.  It does
look like they are suggesting that a core network change is also needed,
I'll find out what is going on there.

> - ftp://distfiles.pld-linux.org/distfiles/by-md5/8/e/8e4764f6c438427b00fb9aa93abb3cd7/toshbt-1.0.tar.gz

This is a bit odder, but might just be needed for one brand of laptop.
I'll ask to find out, at the least it needs to be changed to not use
/proc/ anymore, which is easily done.

thanks for the pointers, if anyone has any others, please let me know.

greg k-h
