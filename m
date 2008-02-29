Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYB2BnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYB2BnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYB2BnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:43:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37524 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYB2BnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:43:01 -0500
Date: Fri, 29 Feb 2008 10:43:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: cpuset trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
Cc: kosaki.motohiro@jp.fujitsu.com, "Paul Jackson" <pj@sgi.com>,
       linux-kernel@vger.kernel.org, trivial@kernel.org, clameter@sgi.com,
       menage@google.com
In-Reply-To: <9a8748490802281443v62252343y5987e432df9462bd@mail.gmail.com>
References: <20080219073450.7479cb00.pj@sgi.com> <9a8748490802281443v62252343y5987e432df9462bd@mail.gmail.com>
Message-Id: <20080229104150.66D0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

Thanks.
but Andrew Morton already pushed to linus.

> > > -automatically tracks the value of node_states[N_MEMORY]--i.e.,
> >  > +automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,
> >
> > Thanks.
> >
> >  Acked-by: Paul Jackson <pj@sgi.com>
> >
> 
> If no one else picks this up, I'll submit it to Linus via the trivial
> tree when the next merge window opens.


