Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZFFAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZFFAU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZFFAUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:20:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZFFAUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:20:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: naresh kamboju <naresh.kernel@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong 
	->nsproxy usage
In-Reply-To: naresh kamboju's message of  Friday, 5 June 2009 21:13:13 +0530 <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
References: <20090525185502.GA20781@redhat.com>
	<20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	<20090526213346.GA7073@redhat.com>
	<20090527005527.B50B7FC36B@magilla.sf.frob.com>
	<20090602045418.GB8219@us.ibm.com>
	<f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
X-Shopping-List: (1) Gubernatorial holidays
   (2) Didactic consoles
   (3) Puerile curious gravy
   (4) Scary redeemer benedictions
Message-Id: <20090606001949.B1E54FC3CB@magilla.sf.frob.com>
Date: Fri,  5 Jun 2009 17:19:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has absolutely nothing to do with the patch/thread you replied to.
Post about your signals issues separately.
