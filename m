Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXEBI2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXEBI2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXEBI2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:28:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34163 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbXEBI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:28:46 -0400
X-Originating-Ip: 74.109.98.66
Date: Wed, 2 May 2007 04:28:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Valdis.Kletnieks@vt.edu, Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so ... what *are* candidates for removal?
In-Reply-To: <4637C04E.4070306@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0705020418530.7102@localhost.localdomain>
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>      
      <46375D1C.4050404@tomt.net> <10590.1178037443@turing-police.cc.vt.edu>
 <4637C04E.4070306@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Stefan Richter wrote:

> Regarding features that are overdue for removal according to
> feature-removal-schedule.txt:
>
> I remember that at least one person used to watch for due dates for
> feature removal, wrote the removing patches, and sent them to the
> appropriate lists and maintainers.  This either got rid of the
> obsolete stuff, or it turned up reasons why some feature could not
> be removed just yet and how to update feature-removal-schedule.txt
> to correctly reflect that.
>
> So, as they say, Patches Are Welcome.

that's a nice idea, but it doesn't address the problem that someone
might go to the trouble to create such a patch and send it in, only to
have that submission generate shrieking along the lines of "OHMIGOD,
we can't delete that *yet*!!!"

that's the whole point of this wiki page:

http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed

it's meant for active participation to converge on a *consensus* as to
what should go and what shouldn't, *after* which the features removal
file can be updated appropriately and patches can start to be
generated.

it's incredibly wasteful to take the time to create and submit a
feature removal patch that ends up just *establishing* that something
shouldn't be deleted yet.  i'm sure most people here can think of
better things to do with their time.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
