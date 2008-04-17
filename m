Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbYDQHqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbYDQHqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYDQHqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:46:01 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:26541 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbYDQHqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lkSK9lPFkaGQrMzlmBnYN7nGR6EGLyFK7UBa9X3/4iZrFiuRK+NwdNy4ES2M1KisWsPoZbHy4yDcZtLoUnyPh9BlhC9cJNtPP/vt4NmzqUnCnHs/0unfVDz40BN/4PT7GbZp9QqvMaApiFADjVQj6rnw6B3FP+XCHQbYlRWLG4I=
Message-ID: <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
Date: Thu, 17 Apr 2008 10:45:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080417002552.5742ad65.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu>
	 <20080417002552.5742ad65.akpm@linux-foundation.org>
X-Google-Sender-Auth: dc41a58ff4bda2a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 10:25 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  > Soren Sandmann (1):
>  >       x86: add the debugfs interface for the sysprof tool
>
>  Also, I (and apparently only I) actually reviewed the implementation and
>  found it to be riddled with bugs and shortcomings.  afacit this was
>  completely ignored and you propose to merge it anwyay?

No, I fixed some of those and I think Ingo/Soren did the rest. But it
needs another round of review on LKML for sure.
