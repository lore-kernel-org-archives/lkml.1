Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbYLHW2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbYLHW2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYLHW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:28:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:2661 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYLHW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:28:00 -0500
Date: Tue, 9 Dec 2008 09:27:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
In-Reply-To: <20081208215221.GA3954@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org>
References: <20081208215221.GA3954@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008, Serge E. Hallyn wrote:

> Documented the currently bogus state of support for CFS user groups with
> user namespaces.  In particular, all users in a user namespace should be
> children of the user which created the user namespace.  This is yet to
> be implemented.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Applied.


-- 
James Morris
<jmorris@namei.org>
