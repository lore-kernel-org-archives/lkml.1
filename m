Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbYCDERp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbYCDERp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbYCDERg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:17:36 -0500
Received: from namei.org ([69.55.235.186]:53037 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753568AbYCDERf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:17:35 -0500
Date: Tue, 4 Mar 2008 15:15:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Paul Moore <paul.moore@hp.com>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 7/9] Audit: internally use the new LSM audit hooks
In-Reply-To: <200803031851.41978.paul.moore@hp.com>
Message-ID: <Xine.LNX.4.64.0803041514090.14650@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu> <20080301200111.GH19636@ubuntu>
 <200803031851.41978.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Paul Moore wrote:

> I've looked over patches #7, #8, and #9 and they look okay to me, but 
> I'm not tagging them 'Reviewed-by' because they go beyond areas of the 
> kernel that I feel comfortable reviewing at this point.

Indeed, deep audit patches need to be acked by the likes of Al Viro (cc'd, 
who possibly should also be added to the MAINTAINERS entry for audit).


- James
-- 
James Morris
<jmorris@namei.org>
