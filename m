Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZKYPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZKYPzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbZKYPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:55:18 -0500
Received: from lazybastard.de ([212.112.238.170]:47305 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZKYPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:55:14 -0500
Date: Wed, 25 Nov 2009 16:55:11 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/17] [LogFS] New flash filesystem
Message-ID: <20091125155510.GE10944@logfs.org>
References: <20091120181113.GA2159@logfs.org> <200911231318.39685.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200911231318.39685.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 November 2009 13:18:39 +0100, Arnd Bergmann wrote:
> On Friday 20 November 2009, Joern Engel wrote:
> > Mails are purely for review and comments.  If this is deemed
> > merge-ready, please the git tree at
> > http://git.kernel.org/?p=linux/kernel/git/joern/logfs.git
> > instead.
> 
> I think merging is overdue, the code looks great and if you're
> happy with it to go in, it's hard for anyone to argue with
> that.
> 
> It should definitely be included in linux-next, and I guess it
> should have been in there for some time, to get better
> compile-time coverage across architectures, and some
> more testing.
> 
> I can't find it in linux-next right now, but I could be
> looking at the wrong stuff again, as I have before.

Stephen,
do you have a reason not to add logfs to linux-next?

Jörn

-- 
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
