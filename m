Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbXHFSOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbXHFSOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765552AbXHFSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:14:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765459AbXHFSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:14:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Tkv1H018GmyhVADKD9w0VcKY0091Z05aBPEkObTavZ/jkKs0+lDHV1JWy4afpMan3
	xf3g/Wq80UoJBIBIViavg==
Date: Mon, 6 Aug 2007 11:09:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       perfctr-devel@lists.sourceforge.net,
       oprofile-list@lists.sourceforge.net
Subject: Re: 2.6.22 new perfmon code base + libpfm + pfmon
In-Reply-To: <20070726140222.GA7852@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0708061107490.2114@chino.kir.corp.google.com>
References: <20070726140222.GA7852@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Stephane Eranian wrote:

> A lot of changes went into this release. A particular thank you to Kevin
> and Robert for providing bug fixes and cleanups to the common code base.
> I would also like to thank David Rientjes (Google) for his detailed code
> review. I have integrated almost all of his remarks in this release.
> Special thanks to Andi Kleen for his code review and his constructive
> remarks.
> 

Stephane, thanks for keeping the patchset updated.  I've reviewed and 
commented on the code where appropriate and I see no reason why it should 
not be included in -mm at this time.  Feel free to add an

	Acked-by: David Rientjes <rientjes@google.com>

before pushing it to Andrew.
