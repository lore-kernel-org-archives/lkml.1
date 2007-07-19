Return-Path: <linux-kernel-owner+w=401wt.eu-S935968AbXGSNhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935968AbXGSNhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759029AbXGSNhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:37:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53522 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586AbXGSNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:37:30 -0400
Date: Thu, 19 Jul 2007 08:37:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719133727.GC32313@sergelap.austin.ibm.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <Line.LNX.4.64.0707190832290.4303@d.namei> <20070719124244.GA7219@vino.hallyn.com> <Line.LNX.4.64.0707190847020.4393@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707190847020.4393@d.namei>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Thu, 19 Jul 2007, Serge E. Hallyn wrote:
> 
> > > It's already pretty clear.
> > 
> > I doubt anyone not on lkml or linux-security-module has heard of this.
> > 
> > So we'll see.
> > 
> > (I was, obviously, talking about end-users)
> 
> If distributions are shipping binary modules and other out of tree code to 
> their users, then they should bear responsibility for supporting and 
> maintaining the infrastructure required for it, and not expect upstream 
> maintainers to do it for them.
> 
> Additionally, if they want to expose their users to risks arising from 
> broken and unecessary infrastructure, then they should bear the cost and 
> responsibility of doing that and not expect others to do so as well.
> 
> I don't see how this is even slightly difficult to understand.

I'm not talking about distros - I don't see how this is even slightly
difficult to understand  :)

The situation I have in mind is someone who decideds to use, say, SLIM,
but wants to otherwise use the distro kernel.

James, relax, I'm done arguing against your patch, I just think
end-users/customers might complain.

-serge
