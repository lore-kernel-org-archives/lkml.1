Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbYLEKIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbYLEKIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYLEKIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:08:34 -0500
Received: from tundra.namei.org ([65.99.196.166]:60036 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYLEKIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:08:34 -0500
Date: Fri, 5 Dec 2008 21:07:55 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] user namespaces: let user_ns be cloned with
 fairsched
In-Reply-To: <20081203191706.GA16433@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0812052106490.14142@tundra.namei.org>
References: <20081203191706.GA16433@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Serge E. Hallyn wrote:

> (These two patches are in the next-unacked branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/userns-2.6.
> If they get some ACKs, then I hope to feed this into security-next.
> After these two, I think we're ready to tackle userns+capabilities)

These look ok to me, but no acks so far.  Any reason not to apply them?


- James
-- 
James Morris
<jmorris@namei.org>
