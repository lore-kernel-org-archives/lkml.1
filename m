Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYBZCBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYBZCBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYBZCA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:00:59 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbYBZCA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:00:59 -0500
Date: Tue, 26 Feb 2008 03:00:57 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Richard Knutsson <ricknu-0@student.ltu.se>
cc: Miles Bader <miles@gnu.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Tabs, spaces, indent and 80 character lines
In-Reply-To: <47C33D74.4010700@student.ltu.se>
Message-ID: <Pine.LNX.4.64.0802260242320.15321@fbirervta.pbzchgretzou.qr>
References: <47C0BEE7.4040409@student.ltu.se> <m3ejb2bdxx.fsf@maximus.localdomain>
 <87zltqcsa2.fsf@catnip.gol.com> <47C33D74.4010700@student.ltu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25 2008 23:13, Richard Knutsson wrote:
> Miles Bader wrote:
>> Why do people even respond to these trolls...?
>>   
> Obviously, this must to have been discussed before, with a clear conclusion.

It has been discussed before, at http://lkml.org/lkml/2007/11/12/19 .

What is really frustrating is that some of the people which _do_ 
enforce one style of the two (tabs-only or tabs-spaces) have only
indirectly voiced their preferred style, as in
http://lkml.org/lkml/2008/1/19/67 .

Often it was just (1)"checkpatch flagged your spaces, hence they are 
wrong" instead of (2)"in my tree, I only take tabs-only patches".


Now back to coding, oh and don't forget send a patch for CodingStyle 
since a mail without one is often taken even less seriously.
