Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZBRLkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZBRLkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 06:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZBRLkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 06:40:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:37587 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZBRLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 06:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=m2wzZcNadRvchNLNaTXNmMFRFYXZoaiZxPw9QckKIyGDCZKwWTq/entdxI6yWFaX41
         VyUl9CBkC/1XKULeYddGBx6oKk1gT9s99eXfpwmUHcRo/QUaYVc1ltljKvENa9hBZW+X
         M2PeevgCx29Pp0X9SGmIoMMe8Nl9+As6UrupE=
Date: Wed, 18 Feb 2009 11:39:53 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com, kaber@trash.net,
       rick.jones2@hp.com, dada1@cosmosbay.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       gandalf@wlug.westbo.se, linux-kernel@vger.kernel.org
Subject: Re: [RFT 2/4] Add mod_timer_noact
Message-ID: <20090218113953.GB5408@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218110144.GA4100@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-02-2009 12:01, Ingo Molnar wrote:
...
> that straight away. Instead you forced me into wasting time on 
> this rather long email (and you also forced the very unnecessary 
> public embarrasment of a contributor), for what should have been 
> an 'oops, right, will fix' routine matter.

No problem! But next time use this shorter routine, please...

Thanks,
Jarek P.
