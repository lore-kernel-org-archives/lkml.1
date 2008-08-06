Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbYHFJil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbYHFJil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbYHFJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:38:29 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:25025 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYHFJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding:sender;
        b=m1Y3rIqEjp/uOJeloOU+X9DhcoMo8LHP3GxF0BsdH4vm+NSIZKS+RDYLEpnfYC+luK
         25wdc3JVqChBi93sS4lhrUGYu6mIux6YgzBY6neuzdZfrivZmsTJrY8C1JDPtjD2GPwr
         BdgS9HKm3VuSHEnrWQNTxKU3HDQoeZ+zYJFtA=
Message-ID: <4899710A.60804@tuffmail.co.uk>
Date: Wed, 06 Aug 2008 10:38:18 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc1-git4: Reported regressions from 2.6.26
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> [Note that all of the suspend/resume regressions seem to result from the same
> couple of bugs, or even one bug, but since that has not been confirmed yet,
> they are listed separately.
> 
> Bug submitters also please note that if you CC your reports to
> kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, they will be _much_ easier to track for me
> and pretty much everybody else.]

Cool.  Will do so in future.

Sorry to be a pest, but can you explain why this address is better than
<kernel-testers@vger.kernel.org>?  It's easier for me to use the latter since I 
can remember it :-).

> This message contains a list of some regressions from 2.6.26, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.

Thanks, having this list helps build my confidence when testing if anything more
is broken in rc2 :-).

Alan
