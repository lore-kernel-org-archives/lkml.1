Return-Path: <linux-kernel-owner+w=401wt.eu-S936998AbXHHBYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936998AbXHHBYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936666AbXHHBV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:21:59 -0400
Received: from namei.org ([69.55.235.186]:47549 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936643AbXHHBV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:21:57 -0400
Date: Tue, 7 Aug 2007 18:21:07 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "Serge E. Hallyn" <sergeh@us.ibm.com>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: file capabilities: clear fcaps on inode change (v3)
In-Reply-To: <20070807231452.GA27198@vino.hallyn.com>
Message-ID: <Pine.LNX.4.64.0708071814520.32311@us.intercode.com.au>
References: <20070807221727.GA12211@sergelap.austin.ibm.com>
 <1186526285.6625.41.camel@heimdal.trondhjem.org> <20070807231452.GA27198@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007, Serge E. Hallyn wrote:

> Yeah, I did that in v1, but didn't want to add two new security_ hooks.
> But I'll send a v4 doing that.

Yep, add what's actually needed.

Continually having to jump through all of these hoops for LSM has gone 
beyond ridiculous.



- James 
-- 
James Morris
<jmorris@namei.org>
