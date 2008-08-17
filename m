Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYHQKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYHQKUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 06:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHQKUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 06:20:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39454 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbYHQKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 06:20:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: PM_TRACE is no longer experimental
Date: Sun, 17 Aug 2008 12:23:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
References: <20080814151833.GA23300@elf.ucw.cz> <48A5B8C8.6040504@imap.cc> <20080817093309.GA8368@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080817093309.GA8368@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171223.41893.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Pavel Machek wrote:
> > On 14.08.2008 17:18 Pavel Machek wrote:
> > > PM_TRACE is stable for quite long. I don't think it needs to depend on
> > > experimental.
> > 
> > It might be stable, but its effect of trashing the RTC makes it unsuitable
> > for non-experimental use. Therefore I'd prefer the dependency be kept.
> 
> Given that it is enabled in both 32-bit and 64-bit defconfig, I don't
> think we can call it experimental.

I agree.

> Plus IIRC it needs command line option to thrash RTC.

That's correct.

Thanks,
Rafael
