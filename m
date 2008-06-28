Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYF1EAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYF1EAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbYF1EAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:00:19 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:25956 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750718AbYF1EAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:00:17 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 00:00:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zdKCJPtF1mUuVKd3iRbUiQHlzfDoo1rzug79iTTichCfY6HAFq1ID8NbhRuJl4uViIzcAfgtPzT3TAehc/4zVOO//o1HU1ibFibj5I7qV2mmZINPNx247kipmSBZz34WRb31fTlVnJr61Yadn+x4OeG6H/Nfun/rOCBhnpv9VdE=;
X-YMail-OSG: XXEX6YQVM1lWLp8vc1X37pr5iOFKwNqOHr.d4_rSLMr7lmwYzTxuh6YOeGyKojsLrUgPrPsiZcutSUyyt6dPrr3.Zs7WK1hGo18_5IH7YpizGIGIcQPaLhFnCoXel2NeUw--
Date: Fri, 27 Jun 2008 20:53:35 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 5/13] EDAC mpc85xx fix pci ofdev
To: Andrew Morton <akpm@linux-foundation.org>, dougthompson@xmission.com,
       Dave Jiang <djiang@mvista.com>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080627155701.72d30927.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <468032.24073.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 27 Jun 2008 12:13:13 -0600
> dougthompson@xmission.com wrote:
> 
> > From:	Dave Jiang <djiang@mvista.com>
> > 
> > Applied to linux-2.6.26-rc5-mm3
> > 
> > Converting PCI err device from platform to open firmware of_dev to comply with
> > powerpc schemes.
> 
> This one doesn't apply due to later changes which should be in 2.6.26-rc8.
> 


mmm, doesn't apply to the -mm3?  

I knew it didn't apply to the 2.6.26-rc5 because there was a patch in the -mm3 which modified the
same code. I assumed that patch would remain in the -mm tree until 2.6.27, therefore I didn't try
the -rc8 code base.  

I applied it 3 times to different 2.6.26-rc5-mm3 trees. The first time there was a problem, but
did new 2.6.26-rc5 trees with a -mm3 and the last 2 times it worked. That puzzled me.

interesting.

ok will resubmit later when we get a newer -mm update

thanks for the help

doug t


W1DUG
