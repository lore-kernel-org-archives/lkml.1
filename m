Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYDGNQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYDGNQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYDGNQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:16:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:40422 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbYDGNP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L10x4r4Eu1gEdLvThPBGujtCp3jH5fciEnv1pMl6FKsiWqzu2Vx/1fuyyOiKrg3gqez3OHJM90k9gYeRJpSIkkqBzJGsSMjE3G+BMxFPTqveMsBN6dOuOq7euILAQt8aTCbeIh8qJQUqDWDPTOpzuuX4cq0peBlCKbeNgFyOw30=
Message-ID: <84144f020804070615y5c4b542s7165935c9d628e0e@mail.gmail.com>
Date: Mon, 7 Apr 2008 16:15:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Cc: LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Paul Mackerras" <paulus@samba.org>
In-Reply-To: <200804071459.35628.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804071459.35628.rjw@sisk.pl>
X-Google-Sender-Auth: 7de61dd52824ebc9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/7 Rafael J. Wysocki <rjw@sisk.pl>:
>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10082
>  Subject         : 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
>  Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>  Date            : 2008-02-20 16:01 (48 days old)
>  References      : http://lkml.org/lkml/2008/2/20/218
>                   http://lkml.org/lkml/2008/1/18/71

Do a git bisect for this as the report isn't getting much attention?
