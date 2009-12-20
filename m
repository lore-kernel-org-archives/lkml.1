Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZLTOZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZLTOZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZLTOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:25:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:57885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZLTOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:25:18 -0500
Date: Sun, 20 Dec 2009 15:27:31 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: sched: restore sanity
Message-ID: <20091220152731.2d1343a7@infradead.org>
In-Reply-To: <1261315437.4314.6.camel@laptop>
References: <1261315437.4314.6.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009 14:23:57 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Revert the braindead pr_* crap.
> 
> it's dumb and causes stupid "sched: " strings all over the place.

yes please; this also broke kerneloops.org parsing ;)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
