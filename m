Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbYFWSWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbYFWSWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbYFWSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:22:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:11328 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022AbYFWSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=mSwwqJYlF5k7gPivFRVilkL33Hckgu7NIF18MwSf64AYOk9VvI8kLbzFOaF/3CRpkB
         XJqYkpgTsPWVoNJbINp0bZlUfocQc6RxNuB5kgRfPeZlYops1ftvQF6d29331T4BfHH/
         +7XNOOIbW0KqTs3RwAD6yDFBdCCG/pJKQMkHE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Date: Mon, 23 Jun 2008 20:19:11 +0200
User-Agent: KMail/1.8.2
Cc: Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       Tim Bird <tim.bird@am.sony.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1209577322.25560.402.camel@pmac.infradead.org> <200806231928.09458.vda.linux@googlemail.com> <20080623174537.GB4756@cs181140183.pp.htv.fi>
In-Reply-To: <20080623174537.GB4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232019.11546.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 19:45, Adrian Bunk wrote:
> Plus the fact that you often get into situations where more options
> mean complex and fragile stuff. Read the Kconfig files under 
> drivers/media/ and check in git all commits to them since 2.6.25 alone, 
> and you'll understand why "add an option for every bit" can result in
> very high ongoing maintainance work required.
> 
> Not everything that is technically possible is also maintainable, and 
> maintainability is a very important point in a project with several 
> million lines changing each year.

Well, I am not (and was not) disputing this. I agree with it.
CONFIGs should not be multiplying like rabbits.
--
vda
