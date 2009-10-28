Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZJ1U4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZJ1U4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZJ1U4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:56:22 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48442 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZJ1U4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:56:22 -0400
Date: Wed, 28 Oct 2009 21:56:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Matt Turner <mattst88@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Cree <mcree@orcon.net.nz>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance
	events.
Message-ID: <20091028205623.GB20363@merkur.ravnborg.org>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz> <20091026084854.GA26990@elte.hu> <b4198de60910271129v5765c963rad8d2f4522112986@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4198de60910271129v5765c963rad8d2f4522112986@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 02:29:52PM -0400, Matt Turner wrote:
> On Mon, Oct 26, 2009 at 4:48 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Is there a tree for Alpha bits?
> 
> No, but really other than a very few scattered patches we don't have
> much activity.
> 
> Maybe it's worth creating one at git.kernel.org? I don't think Richard
> or Ivan are interested in doing it. Could Michael or I do it without
> being maintainers?
If you start handling alpha related stuff then you are automatically becoming
maintainers.
Officially in MAINTAINERS would preferably be with OK from rth and Ivan.

So do not be shy and create such a tree.

	Sam
