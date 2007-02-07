Return-Path: <linux-kernel-owner+w=401wt.eu-S965590AbXBGBak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590AbXBGBak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965596AbXBGBak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:30:40 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57922 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590AbXBGBaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:30:39 -0500
Date: Tue, 6 Feb 2007 17:30:02 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070207013002.GH32307@ca-server1.us.oracle.com>
Mail-Followup-To: Davide Libenzi <davidel@xmailserver.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com> <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org> <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com> <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com> <20070206233907.GW32307@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com> <20070207000626.GC32307@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com> <20070207004443.GE32307@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702061658370.19136@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702061658370.19136@alien.or.mcafeemobile.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 05:15:02PM -0800, Davide Libenzi wrote:
> I think ATM the core kernel implementation should be the focus, because 

	Yeah, I was thinking the same thing.  I originally posted just
to make the point :-)

Joel

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
