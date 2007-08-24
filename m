Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbXHXIa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbXHXIa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbXHXIaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:30:19 -0400
Received: from main.gmane.org ([80.91.229.2]:54211 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbXHXIaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:30:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Suresh Jayaraman <sjayaraman@novell.com>
Subject: Re: Ideas on column length in kernel "problem"?
Date: Fri, 24 Aug 2007 13:47:54 +0530
Message-ID: <1187943467.3831.17.camel@blr-suresh.blr.novell.com>
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
	 <20070823040504.GM30705@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 125.16.129.16
In-Reply-To: <20070823040504.GM30705@stusta.de>
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:54:41PM -0400, Scott Thompson wrote:

> > I haven't seen any recent solutions to this "problem"...
> > 
> > Many free (and not-free) mail clients wordwrap.  Hushmail wraps at 
> > 68 (verified), Yahoo has options to wrap at a max of 99, and Gmail 
> > was somewhere around 85-90 as I recall.  Not sure on other free / 
> > inexpensive clients.

I too had thought about this problem. I think email clients do wordwrap
to improve readability. But, in some cases we just might have to
override. ( I had an experience of sending a malformed patch just
because my wordwrap setting for vim and my email client were different)

What should be ideally expected out of a good email client?
Is it sufficient if the email client provides a facility to disable
wordwrap while inserting file alone and does wordwrap while typing text?
or is it expected to provide a configurable option to enable/disable
wordwrap. I don't think keeping wordwrap disabled all the time is a good
idea because it makes it difficult to read mails.

Do we have a suggested wordwrap setting w.r.t kernel code?

-- 
Suresh Jayaraman


