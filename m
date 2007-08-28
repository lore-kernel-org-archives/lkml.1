Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbXH1XmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbXH1XmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXH1XmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:42:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:14472 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbXH1Xl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EmR9z2e3ornX1estuydBAStVhz373jlxDtPIZVl+QE5MGCt8TTgYRXWrehe0GHfr1fMrw5WOLuo3xxMfNPMh/EmQaZazbITUxdp3X6Rr069sdgGxjaiv9AHWLELXFTYHEuW4ZSbLlX5/oB6p99YEIR/FGAtih8K7hkEvLfm5uB8=
Message-ID: <6bffcb0e0708281641y70261d83u9daf88727baa6149@mail.gmail.com>
Date: Wed, 29 Aug 2007 01:41:52 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Harry Edmon" <harry@atmos.washington.edu>
Subject: Re: NFSv4 client OOPS on 2.6.22-rc3 - I meant 2.6.23-rc3
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <46D463C0.6080106@atmos.washington.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D463C0.6080106@atmos.washington.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harry,

On 28/08/07, Harry Edmon <harry@atmos.washington.edu> wrote:
> Typo in my last message - I meant 2.6.23-rc3, not 2.6.22-rc3.  Here it
> is again with correction
>
> I had a kernel oops on my x86_64 dual quad-core Xeon system running
> 2.6.23-rc3.  The system is an NFSv4 client to another 2.6.23-rc3
> system.  The OOPS text is attached and the config file.
>

Is this a regression? Does 2.6.22 work fine?

-- 
LOG
http://www.stardust.webpages.pl/log/
