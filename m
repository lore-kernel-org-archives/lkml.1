Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYEBCyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYEBCyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYEBCyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:54:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:3950 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYEBCyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wS30UkoTmwGVoe+UlD0Oskv+9LkiAarYxLeDwYWy1LRUNQr0nK+hQIhEv0BIlvTxQEp5hZhouR7htpQFb6Y62dPbglQT0QyS9Elog0xFqSPrruDCPbp6tdQah6x4VT2LwPooYyCwKdCd+S2HF1KIrlj1PxTol6OZiBczdUC9vPA=
Message-ID: <f9d2a5e10805011954l12b54802t63b9ce0957b6087b@mail.gmail.com>
Date: Thu, 1 May 2008 19:54:31 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: "Kasper Sandberg" <lkml@metanurb.dk>
Subject: Re: Slow DOWN, please!!!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1209692875.16523.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429.190352.137408408.davem@davemloft.net>
	 <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
	 <4818C0BF.5020002@davidnewall.com>
	 <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org>
	 <4818C571.8040609@davidnewall.com>
	 <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
	 <481947AF.4090101@davidnewall.com>
	 <1209655700.27499.28.camel@localhost>
	 <loom.20080501T174627-71@post.gmane.org>
	 <1209692875.16523.10.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  i can also say that i have noticed this on my own workstation, however
>  thats not really an as valid case, as i have also upgraded userspace and
>  such over time, but it used to be that my box wouldnt use more than
>  ~100mb to boot into X with kde open, and about ~300mb at browsing/mail
>  and such, but these days my workstation easily uses 1.5gb of ram for no
>  apparent reason..
>
>  something certainly is fishy around here, these days people just tend to
>  fix it by throwing 10 times more ram in than should really be necessary,
>  which i guess, is because the ram prices has dropped 10 times
>

So you aren't really contributing anything to the discussion. It could
be userspace, it could be different types of pages you are visiting,
it could be the kernel, you haven't really measured what is taking up
the memory. And of course, its all because developers are lazy. Thanks
for the input.
