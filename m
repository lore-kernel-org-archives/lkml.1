Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbXEXWji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbXEXWji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXEXWjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:39:31 -0400
Received: from web52610.mail.re2.yahoo.com ([206.190.48.213]:30658 "HELO
	web52610.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750701AbXEXWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:39:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dxEQqQSxseznw0D1kF5w+739Y/aKVV8jgC7VNLHBcBLp9+xgSRmppOja82ABmFy+hYQtw0bUJ3v7ug5w6OOREQ7FZOKi1hstZPL/wTBjyrG+H3NJfRosGQfAUcOJx5D+4DPu6rCuJxKGnh8hqGNoJ9hfVkfDuFp2VQH43SOGjho=;
X-YMail-OSG: PPRr1d0VM1ko6vEVPAOe.U2neFf0dxjCg3c51f5VWqugzMhi5RdJkhMXJfbAlQE6j1p957ANgDs4.VrdYGKjOsJ_3mnYs0g4rnkTMxg40GJBEBzLO8Y-
Date: Fri, 25 May 2007 08:39:28 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705241516330.32086@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <495329.60920.qm@web52610.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Christoph Lameter <clameter@sgi.com> wrote:
> slabinfo -v
[...] 
> Any corrupted objects will be reported to the syslog.

(Only only could have made that sentence better.)

Sorry I didn't know slabinfo -v produces nothing on stdout, stderr, rather all
findings reported to syslog. Right? You don't have to answer this question, if
my assumptions are right.

If so, when ran it produced nothing in the syslog.

Sorry mate, I'm unable to spend a lot of time on slub debugging. I'll
nonetheless keep slub as my preferred memory allocator for the rest of the
2.6.22-rc process. If anything interesting turns up that I could contribute
during this phase, you'll be the first know I promise.

Thanks



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

