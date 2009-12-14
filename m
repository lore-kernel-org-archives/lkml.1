Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZLNBTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZLNBTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZLNBTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:19:40 -0500
Received: from xenotime.net ([72.52.64.118]:37303 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753988AbZLNBTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:19:39 -0500
Date: Sun, 13 Dec 2009 17:19:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Simon Horman <horms@verge.net.au>, liu weni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rs?= =?ISO-8859-1?Q?ter?= 
	<toralf.foerster@gmx.de>
Subject: Re: [PATCH v2]kernel: remove mess codes
Message-Id: <20091213171944.a1ef2af0.rdunlap@xenotime.net>
In-Reply-To: <4B258A27.3050006@goop.org>
References: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
	<4B249210.7060103@goop.org>
	<20091214003320.GA29218@verge.net.au>
	<4B258A27.3050006@goop.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009 16:43:19 -0800 Jeremy Fitzhardinge wrote:

> On 12/13/09 16:33, Simon Horman wrote:
> > On Sat, Dec 12, 2009 at 11:04:48PM -0800, Jeremy Fitzhardinge wrote:
> >    
> >> On 12/12/09 22:55, liu weni wrote:
> >>      
> >>> I found some mess characters(0x0c) in the kernel source code.
> >>> Then I suggest remove it.
> >>>        
> >> Those are form-feed characters.   Some editors use them to separate
> >> logically distinct blocks of code into separate "pages".
> >>      
> > I can see their value in documentation, but I struggle to imagine
> > their usefulness in code.
> >    
> 
> I think a folding editor can fold them out, so you can just expand the 
> area you're interested in.  Or something.  The point is that it is 
> formatting that was presumably put there by the original author.  Unless 
> they're actually upsetting something, I'd be inclined to leave them.

and if someone prints them on paper, the form-feed character will cause
a, uh, form feed (new page).

---
~Randy
