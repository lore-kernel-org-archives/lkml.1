Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZELPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZELPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZELPoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:44:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53302 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753180AbZELPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:44:24 -0400
Date: Tue, 12 May 2009 11:44:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Todd T. Fries" <todd@fries.net>
cc: Clemens Ladisch <clemens@ladisch.de>, David Fries <david@fries.net>,
       David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: bad endpoint address, MOTU FastLane
In-Reply-To: <20090512152153.GA16714@fries.net>
Message-ID: <Pine.LNX.4.44L0.0905121140550.17241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Todd T. Fries wrote:

> I'm actually the owner of said device, and have actually purchased
> something that is complaint.  However, not all owners of said device
> are as able or willing.
> 
> The point in my opinion is that it used to work and now after an upgrade
> (to support a pchdtv.com tuner) the MOTU doesn't, only the software has
> changed.  Thanks for giving me one more reason to avoid Linux.

The fact that it worked before was, as I said, a mere coincidence.  You 
don't seem to appreciate just how badly out-of-spec this device is.

> IMHO the principal of 'be generous in what you accept, strict in what you give..'
> for specs applies here..

That pinciple doesn't help much if what you're trying to accept is 
self-contradictory, as it is in this case.

> Worst case, quirk entry, eh?

If the quirk entry helps, feel free to use it.  And don't be surprised 
if future software upgrades cause similar problems.

Alan Stern

