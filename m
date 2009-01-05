Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZAEBZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZAEBZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZAEBZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:25:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55048 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZAEBZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:25:31 -0500
Date: Mon, 5 Jan 2009 01:25:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: reiserfs broken "unknown uniqueness" (commit
	c1eaa26b671299b3ec01d40c6c71ee19a4f81517)
Message-ID: <20090105012529.GM28946@ZenIV.linux.org.uk>
References: <20090104112436.GT32364@curie-int.orbis-terrarum.net> <b6a2187b0901040453rd914823kb5574f432c71f9f8@mail.gmail.com> <20090105010710.GZ32364@curie-int.orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105010710.GZ32364@curie-int.orbis-terrarum.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 05:07:10PM -0800, Robin H. Johnson wrote:
> On Sun, Jan 04, 2009 at 08:53:29PM +0800, Jeff Chua wrote:
> > It's fixed in the link to this one ...
> >    reiserfs broken with 2.6.28-17244-gb58602a
> Ok, I confirm that Al's patch fixes it, send it to Linus?

It'll go with tonight's pile.
