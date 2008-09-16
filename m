Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYIPODD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYIPODD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYIPOCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:02:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:37959 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYIPOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:02:49 -0400
Date: Tue, 16 Sep 2008 07:02:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Adrian Bunk <bunk@kernel.org>, Jarek Poplawski <jarkao2@gmail.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] net driver fixes
Message-ID: <20080916070241.3e8d5202@infradead.org>
In-Reply-To: <20080916135408.GB13388@mit.edu>
References: <20080916104811.GC7397@cs181140183.pp.htv.fi>
	<20080916114305.GB10965@ff.dom.local>
	<20080916121528.GD7397@cs181140183.pp.htv.fi>
	<20080916135408.GB13388@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 09:54:08 -0400
Theodore Tso <tytso@mit.edu> wrote:

> If it's a really important bug, and it affects a huge number of users,
> or it's really bad security bug, the reality is that exceptions will
> be made to the rules.  But exceptions need to remain exceptions for
> extraordinary situations, not everyday occurrences.  And of course, if
> the bug does affect a huge number of users, someone should be asking
> the question why it wasn't detected sooner, say before the last merge
> window --- and to ask the question how many users is this bug really
> going to affect anyway?
> 
> At least, that's my take on things,
> 

also note that Linus said "regression or on the kerneloops list";
if it has any kind of backtrace, it'll be there if it's a common
problem that hits many users.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
