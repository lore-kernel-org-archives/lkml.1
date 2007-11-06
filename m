Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbXKFREG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbXKFREG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXKFRDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:03:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:36889 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXKFRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JYvfuas/IQf76knDIPwQIpkD8wGAdfq5LNxOKEZW8HWWRj5O4if0jReGHkMyBQRe3QJwYdReQSs5TKsFrvj58ySmQZ/WEUVr2LE0nNvfK/zVPVlSVLhcYxh1b/rI2dcl8aK7smZHIvcZC3KTErMYo9iGIdIbylAhXPrncfVXQi0=
Message-ID: <661de9470711060903w73f6eca4r83a9bdd777bd5366@mail.gmail.com>
Date: Tue, 6 Nov 2007 22:33:51 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: Patch tags [was writeout stalls in current -git]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <28448.1194366312@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071105155749.73e0e38e.akpm@linux-foundation.org>
	 <28448.1194366312@lwn.net>
X-Google-Sender-Auth: bf5745136caf2584
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems like as good an opportunity as any to toss my patch tags
> document out there one more time.  I still think it's a good idea to
> codify some sort of consensus on what these tags mean...
>
> jon
>

[snip]

> +By offering my Reviewed-by: tag, I state that:
> +
> + (a) I have carried out a technical review of this patch to evaluate its
> +     appropriateness and readiness for inclusion into the mainline kernel.
> +
> + (b) Any problems, concerns, or questions relating to the patch have been
> +     communicated back to the submitter.  I am satisfied with the
> +     submitter's response to my comments.
> +
> + (c) While there may be things that could be improved with this submission,
> +     I believe that it is, at this time, (1) a worthwhile modification to
> +     the kernel, and (2) free of known issues which would argue against its
> +     inclusion.
> +
> + (d) While I have reviewed the patch and believe it to be sound, I do not
> +     (unless explicitly stated elsewhere) make any warranties or guarantees
> +     that it will achieve its stated purpose or function properly in any
> +     given situation.

How about adding a Commented-on-by?

Initial version(s) that are not suitable or still shaping up are
commented-on by several people. A person who comments on one version
might not do a thorough review of the entire code, but through a
series of comments has contributed by pushing the developer in the
correct direction.

Balbir
