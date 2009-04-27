Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbZD0XsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbZD0XsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZD0XsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:48:05 -0400
Received: from sous-sol.org ([216.99.217.87]:51986 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbZD0XsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:48:04 -0400
Date: Mon, 27 Apr 2009 16:47:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Chris Frey <cdfrey@foursquare.net>,
       linux-kernel@vger.kernel.org, smfrench@gmail.com
Subject: Re: fs/cifs/connect.c fix missing in latest stable
Message-ID: <20090427234736.GE3036@sequoia.sous-sol.org>
References: <20090427205742.GA888@foursquare.net> <20090427221121.GD3036@sequoia.sous-sol.org> <20090427194441.10bac23d@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427194441.10bac23d@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Layton (jlayton@redhat.com) wrote:
> Yes, we are but they're pretty close. Some have already gone in and
> some are still outstanding. Suresh J. has done the bulk of the work,
> but there are a few additional fixes for other areas too.
> 
> I've been traveling for the last week, and took today off. My plan is
> to get with Steve French tomorrow and finalize a set of fixes for his
> tree that he can push to mainline and stable.

Sounds good, thanks for the update.
-chris
