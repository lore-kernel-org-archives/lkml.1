Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXI2RTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXI2RTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXI2RTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:19:09 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:47082 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753489AbXI2RTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:19:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=BK8kSj5dXe8VjiUaI8DHDbRKR/wyZ9zuPdlSrQE3nyk+Au23E7oCTgSdGF5IFEkW6eDS7DWGWuy1eCXfUIzqSGhvKOoBKcLWpjlKccl156AygRGv2VNTlPJQsnF2sdthvKOgbwnHFSeEKF9Xz4AfhFOHAvNGHRO33mXejvxWT3g=  ;
X-YMail-OSG: aML.4YgVM1m8H_oqKEJ2.aCBbiEF2WzJuRUhwZSxW49dDzO7ev2c7x06K_duJ4Q3x2_BLa.NEha1zQh6_SFxdQsvgyERKqjrxLDGaEXZzKUkbkbvDsivBUHCFsiJzm2TdP71uaAuiFnIXRc-
Date: Sat, 29 Sep 2007 10:19:09 -0700
From: David Brownell <david-b@pacbell.net>
To: khali@linux-fr.org, akpm@linux-foundation.org
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070929122530.5c45f743@hyperion.delvare>
 <20070929035156.cd6fe860.akpm@linux-foundation.org>
In-Reply-To: <20070929035156.cd6fe860.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070929171909.B8275239982@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > -Printing numbers in parentheses (%d) adds no value and should be avoided.
>
> I wonder how that got there.

Well, the only place that numbers "naturally" appear wrapped in
parenthesis is tables of credits and debits... as a debit, sort
of a literal "add no value" situation.  ;)

Oh, and for footnotes, in typographically challenged contexts.

Me, I agree that numbers in parens don't usually make sense for
kernel messages.

- Dave

