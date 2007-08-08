Return-Path: <linux-kernel-owner+w=401wt.eu-S934603AbXHHOKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603AbXHHOKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbXHHOKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:10:24 -0400
Received: from namei.org ([69.55.235.186]:41438 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753574AbXHHOKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:10:21 -0400
Date: Wed, 8 Aug 2007 07:08:25 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: file capabilities: clear fcaps on inode change (v3)
In-Reply-To: <20070808133034.GA2046@vino.hallyn.com>
Message-ID: <Pine.LNX.4.64.0708080707590.18117@us.intercode.com.au>
References: <20070807221727.GA12211@sergelap.austin.ibm.com>
 <1186526285.6625.41.camel@heimdal.trondhjem.org> <20070807231452.GA27198@vino.hallyn.com>
 <Pine.LNX.4.64.0708071814520.32311@us.intercode.com.au>
 <20070808133034.GA2046@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Serge E. Hallyn wrote:

> Here is the next version.  This one involved a bit more actual
> switching of logic so was a bit more nerve-wracking, but it
> seems to be working correctly now.

Looks good to me.

Acked-by: James Morris <jmorris@namei.org>




-- 
James Morris
<jmorris@namei.org>
