Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbXLRCb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbXLRCb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXLRCbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:31:51 -0500
Received: from THUNK.ORG ([69.25.196.29]:55616 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXLRCbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:31:51 -0500
Date: Mon, 17 Dec 2007 21:31:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071218023141.GM7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 04:21:12PM -0800, Linus Torvalds wrote:
> which also gets bonus points for being totally unreadable, and thus 100% 
> in the spirit of uuid's.

Heh.  UUID's don't have to be readable; just universally unique.  Code
on the other hand should be readable.   :-)

If you want something more readable, you could print the MAC address
and boot time.  Of course some crazy people seem to think leaking the
MAC address will somehow be a privacy violation.  And printing a
random UUID is a lot simpler....

						- Ted
