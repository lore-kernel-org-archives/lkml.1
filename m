Return-Path: <linux-kernel-owner+w=401wt.eu-S1423979AbXEEDuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423979AbXEEDuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031730AbXEEDug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:50:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60609
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031729AbXEEDug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:50:36 -0400
Date: Fri, 04 May 2007 20:50:37 -0700 (PDT)
Message-Id: <20070504.205037.91310159.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, jeremy@goop.org, zach@vmware.com,
       torvalds@linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
 for paravirtualization"
From: David Miller <davem@davemloft.net>
In-Reply-To: <m14pmsneql.fsf@ebiederm.dsl.xmission.com>
References: <1178328168.12284.11.camel@localhost.localdomain>
	<20070504.194526.53338219.davem@davemloft.net>
	<m14pmsneql.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 May 2007 21:14:42 -0600

> David Miller <davem@davemloft.net> writes:
> 
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > Date: Sat, 05 May 2007 11:22:48 +1000
> >
> >> Hi Eric,
> >
> > To all of those who don't speak "rusty", "Hi Soandso" means
> > "NAK".
> 
> The question between Rusty and myself is not if we should remove
> that code but when. 

I should have added a smiley face, sorry about that.

I was merely making a joke wrt. a recent blog entry of Rusty's:

	http://ozlabs.org/~rusty/index.cgi/tech/2007-05-04.html

:-)
