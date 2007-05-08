Return-Path: <linux-kernel-owner+w=401wt.eu-S966954AbXEHRpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966954AbXEHRpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966148AbXEHRpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:45:35 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4449 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948AbXEHRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:45:34 -0400
Date: Tue, 8 May 2007 18:45:17 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, David Woodhouse <dwmw2@infradead.org>,
       Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
In-Reply-To: <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz> 
 <1178550653.11851.191.camel@pmac.infradead.org>  <20070507194949.GB3981@ucw.cz>
 <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Satyam Sharma wrote:

> Hmmm ... what if David was German and had a couple of umlauts in his
> name :-) One would expect to at least _spell_ his own name properly in
> his code. Sources need to take care of that too (but we better stick
> to only UTF-8 for source files, wouldn't want to introduce ISO-8859-1
> into the mix too :-)

 Well, my name has an acute above "o" and a dot above "z", but I do not 
have such a high expectation as to have it correctly spelled in comments 
and elsewhere within some code before I am able to get it right in 
official documents issued in English.  And the universe is not going to 
collapse because of the missing accents, so I consider this an issue we 
can think of resolving once we have fixed all the bugs that we have.

  Maciej
