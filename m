Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZGVAUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZGVAUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 20:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZGVAUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 20:20:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZGVAUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 20:20:42 -0400
Date: Tue, 21 Jul 2009 20:20:39 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Ted Merrill <atheros@embuildsw.com>
Subject: Re: khttpd fate
Message-ID: <20090722002039.GF11051@bombadil.infradead.org>
References: <43e72e890907171815x3a85c788k1b4c0f72954db9e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890907171815x3a85c788k1b4c0f72954db9e5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 06:15:40PM -0700, Luis R. Rodriguez wrote:
> I was reviewing khttpd [1] history [2], and the last I see is it was
> merged for the 2.4 kernel with enthusiasm. I don't see any information
> about this for 2.6 though, nor can I find any other notes about why
> this was removed. Just curious if someone recalls why it was removed.
> 
> Also, I really hate how trolly this questions sounds but here it goes anyway:
> 
> Such userspace-kernel hacks shouldn't be necessary anymore based on
> 'performance/latency' arguments right? I take it khttpd wasn't serious
> but more of a hack for fun and now we should be able to laugh about
> it?
> 
> [1] http://www.fenrus.demon.nl/
> [2] http://lwn.net/2001/0118/kernel.php3
> 

I think it kind of got replaced by tux, which Red Hat shipped for a
while, but has been dropped now. I seem to recall davej mentioning a
while ago that apache had gotten much better at serving static content,
which is what khttpd/tux were very good at.

regards, Kyle
