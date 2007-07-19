Return-Path: <linux-kernel-owner+w=401wt.eu-S936422AbXGSNBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936422AbXGSNBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760077AbXGSNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:00:49 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:54060 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbXGSNAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:00:47 -0400
Date: Thu, 19 Jul 2007 09:00:45 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <20070719124244.GA7219@vino.hallyn.com>
Message-ID: <Line.LNX.4.64.0707190847020.4393@d.namei>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
 <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de>
 <20070719122424.GA5186@vino.hallyn.com> <Line.LNX.4.64.0707190832290.4303@d.namei>
 <20070719124244.GA7219@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Serge E. Hallyn wrote:

> > It's already pretty clear.
> 
> I doubt anyone not on lkml or linux-security-module has heard of this.
> 
> So we'll see.
> 
> (I was, obviously, talking about end-users)

If distributions are shipping binary modules and other out of tree code to 
their users, then they should bear responsibility for supporting and 
maintaining the infrastructure required for it, and not expect upstream 
maintainers to do it for them.

Additionally, if they want to expose their users to risks arising from 
broken and unecessary infrastructure, then they should bear the cost and 
responsibility of doing that and not expect others to do so as well.

I don't see how this is even slightly difficult to understand.



- James
-- 
James Morris
<jmorris@namei.org>
