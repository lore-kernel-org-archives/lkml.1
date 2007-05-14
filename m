Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXENUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXENUCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbXENUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:02:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4348 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbXENUC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:02:27 -0400
Date: Mon, 14 May 2007 20:00:11 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       jeffschroeder@computer.org, Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 0/2] file capabilities: Introduction
Message-ID: <20070514200011.GB3969@ucw.cz>
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508130517.ecef3dcb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508130517.ecef3dcb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > Following are two patches which have been sitting for some time in -mm.
> 
> Where "some time" == "nearly six months".
> 
> We need help considering, reviewing and testing this code, please.

I did quick scan, and it looks ok. Plus, it means we can finally start
using that old capabilities subsystem... so I think we should do it.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
