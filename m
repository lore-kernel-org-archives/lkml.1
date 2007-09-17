Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbXIQLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbXIQLSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXIQLSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:18:12 -0400
Received: from mxintern.schlund.de ([212.227.126.201]:63619 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXIQLSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:18:11 -0400
Date: Mon, 17 Sep 2007 13:18:05 +0200
From: Hannah Schroeter <hannah@schlund.de>
To: Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
       "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917111805.GA31443@schlund.de>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916211208.GC5502@thunk.org>
Organization: Schlund + Partner AG
X-UI-Msg-Verification: 9742f87f593e5dc94f573b251246988e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sun, Sep 16, 2007 at 05:12:08PM -0400, Theodore Tso wrote:
>[...]

>What is going on whenever someone changes a code is that they make a
>"derivative work".

Only if the additions/changes are significant enough to be copyrightable
on their own.

>Whether or not you can even make a derivative
>work, and under what terms the derivitive work can be licensed, is
>strictly up to the license of the original.  For example, the BSD
>license says:

>  Redistribution and use in source and binary forms, with or without
>  modification, are permitted provided that the following conditions
>  are met....

>Note the "with or without modification".  This is what allows people
>to change BSD licensed code and redistribute said changes.  The
>conditions specified by the BSD license do not mention anything about
>licening terms --- just that if you meet these three conditions, you
>are allowed to redistribute them.  So for example, this is what allows
>Network Appliances to take BSD code, change it, and add a restrictive,
>proprietary copyright.

Right. You may add nearly any copyright *on your own significant
additions/changes*. However, BSD/ISC explicitly requires to retain the
BSD/ISC terms, too (applicable to the original part of the combined
work).

>So for code which is single-licensed under a BSD license, someone can
>create a new derived work, and redistribute it under a more
>restrictive license --- either one as restrictive as NetApp's (where
>no one is allowed to get binary unless they are a NetApp customer, or
>source only after signing an NDA), or a GPL license.  It is not a
>relicencing, per se, since the original version of the file is still
>available under the original copyright; it is only the derived work
>which is under the more restrictive copyright.   

No. The derivative work altogether has a *mixed* license. BSD/ISC for
the parts that are original, the other (restrictive, GPL, whatever)
license for the modifications/additions.

*If* you choose to distribute source along with the binaries, the part
of the source that's original is BSD/ISC licensed even in the derivative
work (though one may put *the additions/modifications* under restrictive
conditions, e.g. of commercial non-disclosure type source licensing).

>[... dual-licensing issues etc. already handled in other mails ...]

Kind regards,

Hannah.
