Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYIENdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYIENdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYIENdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:33:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:34520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYIENdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:33:16 -0400
Date: Fri, 5 Sep 2008 06:33:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: frame unwinder patches
Message-ID: <20080905063317.5e3a2b2c@infradead.org>
In-Reply-To: <200809051119.21699.bs@q-leap.de>
References: <g9p3du$n95$1@ger.gmane.org>
	<20080904102936.28e10c39@infradead.org>
	<200809051119.21699.bs@q-leap.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 11:19:21 +0200
Bernd Schubert <bs@q-leap.de> wrote:

> > not printing the ? would be trivial (for some backtraces we do
> > that), but so far hasn't been seen as desirable because you lose
> > information in those hard-to-debug cases when you need anything you
> > can get from the backtrace.
> 
> I see your point, but in most cases it is rather annoying.

... if you see backtraces regularly there's something wrong ;-)

(and if you really care it's 1 line of code to turn it off)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
