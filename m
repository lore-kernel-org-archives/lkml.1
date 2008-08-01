Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbYHAX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbYHAX0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYHAX0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:26:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYHAX0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:26:13 -0400
Subject: Re: mtdsuper.c BLOCK=n compile error
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1217632851.3719.47.camel@shinybook.infradead.org>
References: <20080801223056.GK19682@cs181140183.pp.htv.fi>
	 <1217630912.3719.41.camel@shinybook.infradead.org>
	 <20080801225858.GM19682@cs181140183.pp.htv.fi>
	 <1217632851.3719.47.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 00:26:11 +0100
Message-Id: <1217633171.3719.50.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 00:20 +0100, David Woodhouse wrote:
> Er, why is the second bdput() there _anyway_?

Oh, I see. I have to stop posting patches -- I think it's past my
bedtime.

http://git.infradead.org/users/dwmw2/random-2.6.git?a=commitdiff;h=10f8e16418a5a69eda36cdbfc4ad17531c52fe92


-- 
dwmw2

