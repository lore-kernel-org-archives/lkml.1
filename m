Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZJZRqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZJZRqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZJZRqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:46:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41101 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZJZRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:46:13 -0400
Date: Mon, 26 Oct 2009 13:34:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026173404.GF2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com> <20091026172434.GI25725@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026172434.GI25725@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 06:24:34PM +0100, Pavel Machek wrote:
> On Mon 2009-10-26 12:55:19, John W. Linville wrote:
> > On Fri, Oct 23, 2009 at 06:10:06PM +0200, Pavel Machek wrote:

> > > There's no TODO to say what needs to be fixed. You just don't want to
> > > maintain it. Because there's nothing to fix, noone has reason to patch
> > > it, and the (working, good enough) driver will just be removed.
> > 
> > "ongoing maintenance for no clear benefit" -- that is what is wrong
> > with it.
> 
> And how is moving to staging helping with that?

Because no one is required to protect staging drivers from API-change
breakage.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
