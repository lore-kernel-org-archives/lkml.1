Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbXGDBVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbXGDBVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbXGDBVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:21:17 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53869
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757114AbXGDBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:21:16 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][Documentation][resend] Add missing files and dirs to 00-INDEX in Documentation/
Date: Tue, 3 Jul 2007 21:21:02 -0400
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, trivial@kernel.org
References: <200707010106.00181.jesper.juhl@gmail.com> <20070703125852.0172a588.akpm@linux-foundation.org> <9a8748490707031808m73093345i141b772b283a9d04@mail.gmail.com>
In-Reply-To: <9a8748490707031808m73093345i141b772b283a9d04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032121.02333.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007 21:08:32 Jesper Juhl wrote:
> > That's Rob's problem, I guess.
>
> Let's leave final judgement of the patch to Rob then. That's fine by me.

I plan to obsolete it within the next month, but for 2.6.22 you might as well 
update it.  I'll integrate that data that's there into http://kernel.org/doc 
when I get a little less buried.  (I might set up a git tree and queue up 
Documentation reorganization patches too.  But probably not this week.)

So:
Signed-off-by: Rob Landley <rob@landley.net>

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
