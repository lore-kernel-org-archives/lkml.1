Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYACO6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYACO6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYACO6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:58:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56851 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYACO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:58:22 -0500
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
From: David Woodhouse <dwmw2@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080103145028.GH8046@cvg>
References: <20080103111925.GC8046@cvg>
	 <20080103112957.GA14693@lazybastard.org> <20080103140549.GA19363@elte.hu>
	 <1199370550.3697.79.camel@shinybook.infradead.org>
	 <20080103143711.GA29606@elte.hu>
	 <1199371044.3697.80.camel@shinybook.infradead.org>
	 <20080103145028.GH8046@cvg>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 14:57:08 +0000
Message-Id: <1199372228.3697.82.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 17:50 +0300, Cyrill Gorcunov wrote:
> 
> 
> so what i would do now? i could post updated patch *without* that
> splitted line, should I?

And with the if (rc == 0) thing fixed too. Yes please.

-- 
dwmw2

