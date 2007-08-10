Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbXHJRL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbXHJRL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXHJRLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:11:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbXHJRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:11:07 -0400
Date: Fri, 10 Aug 2007 10:10:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.23-rc2-mm2
Message-Id: <20070810101053.dd4aad69.akpm@linux-foundation.org>
In-Reply-To: <20070810160519.GA27500@elte.hu>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC7BDA.3000305@googlemail.com>
	<6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com>
	<m11webz8dx.fsf@ebiederm.dsl.xmission.com>
	<20070810160519.GA27500@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 18:05:19 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> > Yes.  For the sched debug case I sent Ingo and friends but apparently 
> > other changes in Ingos tree kept it from applying and Andrew dropped 
> > it.

No, I know nothing about such a patch.

>  So instead the code now screams at you and refuses to register 
> > Ingo sysctl table.
> 
> the commit below is now upstream

and it's in rc2-mm2.

> - is your patch still needed?

Something's needed ;)
