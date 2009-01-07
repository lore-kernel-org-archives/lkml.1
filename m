Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZAGIun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZAGIun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZAGIuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:50:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:18699 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZAGIub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:50:31 -0500
Message-Id: <49647B00.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 08:50:56 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: <ccache@lists.samba.org>, "Sam Ravnborg" <sam@ravnborg.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu>
In-Reply-To: <20090106173300.GA10903@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Theodore Tso <tytso@mit.edu> 06.01.09 18:33 >>>
>On Tue, Jan 06, 2009 at 03:29:35PM +0000, Jan Beulich wrote:
>> >>> "Theodore Ts'o" <tytso@mit.edu> 06.01.09 16:15 >>>
>> >In the short term, though, it would be nice if we could get back a
>> >simple way of making a kernel  object file using just cc, so that ccache
>> >and distcc could be functional again.   Does that seem reasonable?
>> 
>> Making the new logic dependent on a config option would seem reasonable
>> to me - of course at the expense of the respective Makefile becoming
>> even less readable.
>
>Too late.  :-) It's pretty unreadable already.... as a result, I'm not
>at all confident that I could make such a patch.  Is this something
>you could perhaps whip up?  I'd really appreicate it, as it would
>seriously speed up by kernel development efforts.

Yes, I think I could (and in fact I already put it on my to-do list), but I can't
give a good prediction on when I'd be able to get to it.

Jan

