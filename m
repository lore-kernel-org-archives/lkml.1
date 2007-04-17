Return-Path: <linux-kernel-owner+w=401wt.eu-S1161391AbXDQWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161391AbXDQWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161397AbXDQWcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:32:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161390AbXDQWcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:32:31 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070417221245.GD11944@one.firstfloor.org>
References: <20070417181016.GA10903@one.firstfloor.org>
	 <657751.18080.qm@web36614.mail.mud.yahoo.com>
	 <20070417211653.GB11944@one.firstfloor.org>
	 <1176846088.5946.62.camel@localhost.localdomain>
	 <20070417221245.GD11944@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 18:29:14 -0400
Message-Id: <1176848954.5946.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 00:12 +0200, Andi Kleen wrote:
> > The vast majority of applications are not
> > modified to be SELinux aware - only a small handful of security aware
> > applications are modified. 
> 
> All applications that can edit /etc/resolv.conf? That's nearly 
> everything. You yourself gave the example; I'm not making anything up.
> 

No - read my other mail on this subject.

> 
> -Andi (sensing a loop in the thread -- things that already have been
> discussed come back from the dead.)
> 
> P.S.: If you want to loop further please drop me from cc.
> 

I might be wrong, but I think that the loop is partially coming from you
not understanding how policy normally handles labeling. There is some
information at http://www.nsa.gov/selinux/papers/slinux/node16.html.

Karl

