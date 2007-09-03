Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbXICKOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbXICKOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbXICKOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:14:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9769 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbXICKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AO6Svl92m6glP//Kl+zqxW9RAelSc7577WCow4FQXMY/XDnafbe/eyFXWFbU9rSJG3XSU8sCRlRp8XaN2tFOByG5juz5Ow5+qKnmboDrbWlZ5fE56pNG9pPXF7ynBQNdXClvXx7NK4opJoteAXI+62b1x/zWF1qLFLWre6COfz0=
Message-ID: <6bffcb0e0709030314t28c0102dr41f3c7b75b134cfa@mail.gmail.com>
Date: Mon, 3 Sep 2007 12:14:05 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: [1/4] 2.6.23-rc5: known regressions
Cc: LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
In-Reply-To: <46DBDDF0.3090203@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46DBDD6E.9020007@googlemail.com> <46DBDDF0.3090203@l4x.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/07, Jan Dittmer <jdi@l4x.org> wrote:
> Michal Piotrowski wrote:
> > Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
> > References      : http://lkml.org/lkml/2007/8/6/43
> > Last known good : alpha: 2.6.22-git8
> >                   xtensa: 2.6.22-git6
> > Submitter       : Jan Dittmer <jdi@l4x.org>
> > Caused-By       : ?
> > Handled-By      : xtensa: Christian Zankel <chris@zankel.net>
> > Status          : unknown
>
> Both are fixed as of -rc5

Thanks. I will try to figure out who fixed these bugs.

>
> Jan
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
