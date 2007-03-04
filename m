Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbXCDW3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbXCDW3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 17:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXCDW3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 17:29:32 -0500
Received: from mail08.syd.optusnet.com.au ([211.29.132.189]:36572 "EHLO
	mail08.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbXCDW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 17:29:32 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Gerald Britton <gbritton@doomcom.org>
Subject: Re: [PATCH] [RSDL 1/6] lists: add list splice tail
Date: Mon, 5 Mar 2007 09:29:14 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200703041802.13991.kernel@kolivas.org> <20070304173310.GA20939@zante.sekrit.org>
In-Reply-To: <20070304173310.GA20939@zante.sekrit.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050929.15165.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 04:33, Gerald Britton wrote:
> On Sun, Mar 04, 2007 at 06:02:13PM +1100, Con Kolivas wrote:
> > Add a list_splice_tail variant of list_splice.
> >
> > Patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Con Kolivas <kernel@kolivas.org>
>
> ...
>
> > @@ -360,6 +386,22 @@ static inline void list_splice_init(stru
> >  }
> >
> >  /**
> > + * list_splice_init - join two lists at one's tail and reinitialise
> > emptied
>
> You should update the comment to match the function.

Doh! Thanks. I'll fix it in the split out patches I have on my web site for 
now.

-- 
-ck
