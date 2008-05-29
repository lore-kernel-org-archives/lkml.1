Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbYE2V03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbYE2V03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYE2V0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:26:21 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:32018 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925AbYE2V0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:26:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Lyo8wrYwoiu42iPLyIdmXfU9dt1tKGJALBkbtHMlBNoIAw9Fem+x96II8NmaINOh9uCyuBmz/G2895iHnUMNy1SAZ3b6hp4zrzBDiw1zx1Fqa9D7I2B3oCKYkv9VA/e6WMlwJc2QnLAwHyIWAgkOGL3a+fPdQyGn11/AB49OrE4=  ;
X-YMail-OSG: 0a9FueoVM1nABPUaYmtABXYbswmkcAh9SnJ9oN92uT9kDi6s1IJfzXu0gjz1CsANfqTYDqoGBdR0b_V9uApr8rsxiqXJU7WdovKMrGnMjobXcEgLSaBElfpaendzGrgnbOc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Date: Thu, 29 May 2008 14:26:18 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>
References: <200805291333.42057.david-b@pacbell.net> <200805292301.42244.rjw@sisk.pl>
In-Reply-To: <200805292301.42244.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291426.18404.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008, Rafael J. Wysocki wrote:
> Two questions:
> 
> 1) How is it related to the analogous patch in the Ingo's tree?

AFAIK -- just that it's an updated version.  Comments, some
code flow, but mostly having the "test_suspend=mode" parameter
default to "safe -- no testing" and allows the choice of modes.


> 2) Does it apply to the current linux-next?

No idea.



