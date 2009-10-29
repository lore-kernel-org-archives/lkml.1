Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZJ2OPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZJ2OPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZJ2OPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:15:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:28496 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZJ2OP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=W9Bcq+VM6J/9YCyB9vRkEx2lg54yV4ta11jZTWmlbeL5T9s8rkjl2Xl4TffhMsFwwL
         ERTFDjWy4v27Pz2yURClcsma7WNJQPvFRZcv4S0CBlJAaymwxVGC0lEYJh74diQsLEVQ
         9k8c9C0PZcY6pydWiq+q3LpLUNRjt9HQZUcLQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 15:14:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
References: <200910291212.41656.bzolnier@gmail.com> <200910291435.54203.bzolnier@gmail.com> <84144f020910290652n2e75827dk698b238b6bd1cbed@mail.gmail.com>
In-Reply-To: <84144f020910290652n2e75827dk698b238b6bd1cbed@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200910291514.40318.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 29 October 2009 14:52:50 Pekka Enberg wrote:
> Hi Bart,
> 
> On Thu, Oct 29, 2009 at 3:35 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >> I'm saying that you should work with John to have him send a revert or
> >> whatever to me.
> >
> > This is your responsibility to deal with your downstream maintainers,
> > not mine and since you have accepted John's patch I'm asking you to
> > revert rt2800pci patch from your tree.
> 
> So why don't you just send a patch to fix it up? I see you're doing

"git revert a9b3a9f"

done.

Dave, if you have problems with executing the command locally I'll be
happy to supply you with the patch.

> lots of cleanups to the staging drivers, why not direct some of that
> energy to the drivers/net/wireless ones?

When did we start to apply "fix it yourself" rule instead of "submitter
should fix it" one to the _new_ code..

rt2800 drivers have their maintainers and I would like to know what they
are doing besides complaining about users and staging tree..

-- 
Bartlomiej Zolnierkiewicz
