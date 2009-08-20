Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZHTWHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZHTWHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZHTWHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:07:51 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:38523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751684AbZHTWHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:07:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Fcc: ~/Mail/linus
Cc: Helge Deller <deller@gmx.de>, John David Anglin <dave@hiauly1.hia.nrc.ca>,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave.anglin@nrc.ca
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: James Bottomley's message of  Thursday, 20 August 2009 15:50:49 -0600 <1250805049.4302.121.camel@mulgrave.site>
References: <20090820185550.979544E7A@hiauly1.hia.nrc.ca>
	<4A8DC3ED.4060005@gmx.de>
	<1250805049.4302.121.camel@mulgrave.site>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090820220739.F2E554730F@magilla.sf.frob.com>
Date: Thu, 20 Aug 2009 15:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since this is a relinked object, might it be possible that ld rather
> than gcc is the culprit?

I don't think ld -r does any of that sort of magic.

Thanks,
Roland
