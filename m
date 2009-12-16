Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbZLPS62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbZLPS62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbZLPS61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:58:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:50762 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLPS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:58:25 -0500
Subject: Re: perf and libdwarf on debian
From: Peter Zijlstra <peterz@infradead.org>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20091216183822.GA18410@boogie.lpds.sztaki.hu>
References: <20091216135448.GD11618@aftab>
	 <1260988340.21028.198.camel@laptop>
	 <20091216183822.GA18410@boogie.lpds.sztaki.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 19:58:13 +0100
Message-ID: <1260989893.21028.238.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 19:38 +0100, Gabor Gombas wrote:
> On Wed, Dec 16, 2009 at 07:32:20PM +0100, Peter Zijlstra wrote:
> 
> > Then again, its not like debian would ever ship something recent enough
> > to actually build perf with, even my karmic machine comes with
> > libdwarf-20080409 which to me reads like ancient and not befitting a
> > distro released a month or so ago.
> 
> "karmic" sounds Ubuntu, not Debian. In Debian:

And here I thought ubuntu was generally a less ancient debian..



