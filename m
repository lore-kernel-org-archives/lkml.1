Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbXITPYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbXITPYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbXITPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:24:16 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:42058 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXITPYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=R8SmZDfsdttZeH8mt9x99JlCCsUl36AnMsDr8AlflEps0ESYN5vh7giIfYB8pVP1B5hF+Ouhh97jN/ppU4c9lCwfti/61ueDqDXNnsC5lbBMRueHRNvLRKDb4RPk6pvbqz/4DKgM7ZOGcseWQbUCW2BPOX3ah05b0gnLiMPwMhU=
Date: Thu, 20 Sep 2007 18:24:06 +0300
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Low Yucheng <ylow@andrew.cmu.edu>, Oleg Verych <olecom@flower.upol.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
Message-ID: <20070920152406.GA2562@Ahmed>
References: <20070919192546.GA3153@Ahmed> <20070920100031.GA2796@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920100031.GA2796@ff.dom.local>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 12:00:31PM +0200, Jarek Poplawski wrote:
> On 19-09-2007 21:25, Ahmed S. Darwish wrote:
> > Hi Low,
> > 
> > On Wed, Sep 19, 2007 at 12:16:39PM -0400, Low Yucheng wrote:
> >> There are no additional console messages.
> >> Not sure what this is: * no relevant Cc (memory management added)
> > 
> > Relevant CCs means CCing maintainers or subsystem mailing lists related to your
> > bug report. i.e, if it's a networking bug, you need to CC the linux kernel
> > networking mailing list. If it's a kobject bug, you need to CC its maintainer
> > (Greg) and so on.
> 
> So, which one do you recommend here?
> 

I'm not really sure, just wanted to solve Jarek's confusion :).

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
