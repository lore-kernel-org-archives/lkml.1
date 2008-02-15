Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbYBOWy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbYBOWy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbYBOWjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:39:33 -0500
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:40542 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932782AbYBOWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:39:31 -0500
X-YMail-OSG: .DKXv6oVM1mkM_HTVq20oynPqndUjL34qOaF3dCp8MS2JWMsPQcWBfFq6lF93qT0R_oSlwWsig--
X-RocketYMMF: rancidfat
Date: Fri, 15 Feb 2008 14:39:30 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] (02/14/08 Linus git) Smack unlabeled outgoing ambient packets - v3
To: Paul Moore <paul.moore@hp.com>, casey@schaufler-ca.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <200802151637.14835.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <57418.15966.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Paul Moore <paul.moore@hp.com> wrote:


> > Yerk. I can put that fix into my tree, but my patch without
> > the "correction" makes sockets behave very badly. I can't have
> > people using it without Pavel's fix. Any notion on the plans to
> > get that in?
> 
> FYI, it looks like Linus just tagged -rc2 and it does have the fix you 
> need.

Thank you. Verification in progress.


Casey Schaufler
casey@schaufler-ca.com
