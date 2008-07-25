Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYGYKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYGYKXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYGYKXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:23:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39796 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330AbYGYKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:23:08 -0400
Date: Fri, 25 Jul 2008 11:05:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
Message-ID: <20080725110539.3e775940@lxorguk.ukuu.org.uk>
In-Reply-To: <4889615D.9020706@nortel.com>
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain>
	<h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com>
	<alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
	<20080724211141.4fa557ca@lxorguk.ukuu.org.uk>
	<4889615D.9020706@nortel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 01:15:09 -0400
"Chris Friesen" <cfriesen@nortel.com> wrote:

> Alan Cox wrote:
> >> legitimately experimental content in the source tree.  surely *some*
> >> of that is suitably mature such that that dependency can be dropped.
> > 
> > What is the connection between age of code and experimental status ?
> 
> Is it reasonable for in-tree code to remain "experimental" indefinately?

I would certainly think so. We have stuff which is very long term
experimental (often because the vendor of the hardware won't provide
docs) but it is better to have this than nothing.
