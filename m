Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXFVByV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXFVByV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXFVBxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:53:51 -0400
Received: from paragon.brong.net ([66.232.154.163]:54433 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbXFVBxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:53:49 -0400
Date: Fri, 22 Jun 2007 11:18:12 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070622011812.GF30132@brong.net>
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 06:39:07AM -0300, Alexandre Oliva wrote:
> If GPLv3 were to have a clause that permitted combination/linking with
> code under GPLv2, this wouldn't be enough for GPLv3 projects to use
> Linux code, and it wouldn't be enough for Linux code to use GPLv3
> projects.  That's because GPLv2 would still demand all code to be
> licensed under GPLv2, and GPLv3 wouldn't permit this.
> 
> However, if GPLv3 had a permission to combine/link with code under
> GPLv2, *and* Linux (and any other projects interested in mutual
> compatibility) introduced an additional permission to combine/link
> with code under GPLv3 (or even GPLv3+, constrained by some condition
> if you will), then:

My god, you really have come totally unhinged in your attempt to
reconcile two incompatible ideas.  Ouch.

The reason the GPLv2 ecosystem is so strong is that you can take any
code under GPLv2 and combine it with any other code under GPLv2 and the
result is GPLv2.  All you have to check is that the original code is
either GPLv2 or a licence that allows conversion to GPLv2, that's it.

None of this "Projects" nonsense.

Who says what code is a "project" and if it has any special
relationships with other "projects" that allow code sharing above and
beyond their standard licence terms.  Suddenly using other GPLv2 code
becomes fraught with "which path did I obtain this licence down" games
and either a big fat pile of paperwork or plain not being able to be
clear about the licencing of of the code.

It's not about projects, it's about the code.  Gah.  You're not going
to make a happy, happy merging code sharing world by fragmenting the
licence landscape even more.

Bron.
