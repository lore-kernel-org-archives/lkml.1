Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZFGMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZFGMeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZFGMeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:34:02 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63459 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZFGMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QwHkZABDAQXneZ9q51CUtdvkwcNENbODoA0dbndEHHy57CReepWNQt/6fJVaj27lqY
         YmOAAz7xDUUFZ9KH1SJy4qFW8Run4NAWO7dFwXzX+MwQWz2QbYFrxwLjVExTI2AZMwog
         TwSggi2v7twJtaa6EE4wMfrGGaW+N9SKHXDTA=
Subject: Re: [PATCH] KVM: Add VT-x machine check support v2
From: Huang Ying <huang.ying.caritas@gmail.com>
Reply-To: huang.ying.caritas@gmail.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ying.huang@intel.com
In-Reply-To: <20090607103514.GA22266@one.firstfloor.org>
References: <20090605232356.GA7091@basil.nowhere.org>
	 <4A2B57B9.7070207@redhat.com>  <20090607103514.GA22266@one.firstfloor.org>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 20:26:01 +0800
Message-Id: <1244377561.14521.2.camel@caritas-mobile.ml.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 12:35 +0200, Andi Kleen wrote:
> On Sun, Jun 07, 2009 at 09:01:29AM +0300, Avi Kivity wrote:
> > >v2: Handle machine checks still in interrupt off context
> > >to avoid problems on preemptible kernels.
> > >
> > >Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > >
> > >  
> > 
> > Only applies with -C0.  What tree was this generated against?
> 
> 2.6.30-rc7
> 
> > Please diff and test against latest kvm.git.
> 
> Sorry can't do neither for the next two weeks.

I will do this.

Best Regards,
Huang Ying


