Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbYETAjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbYETAjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbYETAjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:39:06 -0400
Received: from namei.org ([69.55.235.186]:44302 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757161AbYETAjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:39:05 -0400
Date: Tue, 20 May 2008 10:37:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: lsm <linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] security:  split proc ptrace checking into read vs.
 attach
In-Reply-To: <1211200369.7486.38.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0805201035550.8661@us.intercode.com.au>
References: <1211200369.7486.38.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Stephen Smalley wrote:

> No change in the patch since the prior RFC.  I think this is ready for the
> for-akpm branch of selinux, targeting 2.6.27.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm



- James
-- 
James Morris
<jmorris@namei.org>
