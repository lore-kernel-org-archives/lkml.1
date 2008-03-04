Return-Path: <linux-kernel-owner+w=401wt.eu-S1763371AbYCDEK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371AbYCDEK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbYCDEKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:10:46 -0500
Received: from namei.org ([69.55.235.186]:52651 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028AbYCDEKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:10:45 -0500
Date: Tue, 4 Mar 2008 15:09:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Paul Moore <paul.moore@hp.com>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 7/9] Audit: internally use the new LSM audit hooks
In-Reply-To: <20080304033109.GA28637@ubuntu>
Message-ID: <Xine.LNX.4.64.0803041508060.8815@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu> <20080301200111.GH19636@ubuntu>
 <200803031851.41978.paul.moore@hp.com> <20080304033109.GA28637@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Ahmed S. Darwish wrote:

> Yes, it's something weird. I've generated all of those diffstats (including
> the right ones) in the same way. Luckily the problem is reproduceable,
> I'll check the latest upstream diffstat version and see what happens.

git-format-patch should "just work".



-- 
James Morris
<jmorris@namei.org>
