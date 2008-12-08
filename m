Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYLHWoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYLHWoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYLHWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:44:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47697 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYLHWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:44:07 -0500
Date: Mon, 8 Dec 2008 16:44:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
Message-ID: <20081208224405.GA6077@us.ibm.com>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Mon, 8 Dec 2008, Serge E. Hallyn wrote:
> 
> > Documented the currently bogus state of support for CFS user groups with
> > user namespaces.  In particular, all users in a user namespace should be
> > children of the user which created the user namespace.  This is yet to
> > be implemented.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> 
> Applied.

Thanks, James.

-serge
