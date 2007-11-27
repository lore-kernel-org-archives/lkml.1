Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXK0Wz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXK0Wz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXK0WzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:55:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:1395 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXK0WzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=JE/oV3njtXcuq6CxbmTdz8GI+3+YP0tqTRd9myyXaIzcc75iCO8SGMvQdHdX4ctfVErdhyMvkLDuEWGTVjsXM00AXzQOV2wUu7PbGcU0ke7a9rjscuQcrYu3EKlGOodl5BrR6Q2AjnRxRfKBKemtZMrmLNJ57PbQdRI3Raha0mk=
Date: Tue, 27 Nov 2007 23:55:11 +0100
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
Message-Id: <20071127235511.bd9557f0.Kristoffer.ericson@gmail.com>
In-Reply-To: <474C9B31.8000408@imap.cc>
References: <474C9B31.8000408@imap.cc>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Google is your friend. If you're looking for irc channels you can always try #git at irc.freenode.net
Git howto/tutorial/... doesn't belong in the kernel mailinglist.

Best wishes
Kristoffer Ericson

On Tue, 27 Nov 2007 23:33:21 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> So I've watched Linus' Google Tech Talk about git and let him convince
> me that I've been stupid to use CVS, that Subversion is even worse,
> and the only sensible approach is to use git. Went ahead and tried to
> convert my driver development to git.
> 
> It didn't work too well. The first result was one of maximal
> embarrassment: I produced a patch that didn't even compile when
> applied to the official tree. This shouldn't happen with git, right?
> Well, it did. So now I'm back to keeping a virgin kernel source tree
> alongside my development area in order to produce diffs. That can't
> be right?
> 
> Obviously I'm still being stupid. (Probably an aftereffect of using
> CVS for too long.) But where do I turn for guidance? I read all the
> docs and READMEs I could find, but I still don't understand why GIT
> doesn't produce the results I need, and what to do differently.
> 
> Does somebody have a step by step tutorial for doing the standard
> "edit - test - modify - retest - submit - edit - resubmit" sequence
> with GIT? Is there a GIT newsgroup or mailinglist? Or should I just
> post my silly questions to LKML?
> 
> TIA
> 
> -- 
> Tilman Schmidt                          E-Mail: tilman@imap.cc
> Bonn, Germany
> Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
> Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
> 
> 
