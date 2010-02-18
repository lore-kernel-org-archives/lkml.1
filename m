Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0BRSR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:17:56 -0500
Received: from thunk.org ([69.25.196.29]:33359 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab0BRSRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:17:55 -0500
Date: Thu, 18 Feb 2010 13:17:53 -0500
From: tytso@mit.edu
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
Message-ID: <20100218181753.GJ5337@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Jiri Kosina <trivial@kernel.org>
References: <20100218095200.63509b8c@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218095200.63509b8c@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:52:00AM -0700, Jonathan Corbet wrote:
> The ChangeLog file under drivers/char is 30K of stuff dedicated to the
> mid-90's TTY exploits of Ted Ts'o; it has been updated once since 1998
> - and that was in 2001.  It's interesting history, but we don't
> normally carry that kind of history inline with the code.  Let's remove
> it.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Ah, for those good old days when Linus refused to use a SCM (may they
never return! :-)

						- Ted
