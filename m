Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZH0VhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZH0VhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZH0VhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:37:12 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:16327 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753197AbZH0VhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:37:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: B3Dj DRJW E7Sg GoJg HqoE Kdvq PGoQ RHXi SAP0 TzcP XHSo bxLR cWR8 cmCv euSl hy7N;3;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAYQBuAGQAeQAuAGQAdQBuAGwAYQBwAEAAbwByAGEAYwBsAGUALgBjAG8AbQA7AHQAbwByAHYAYQBsAGQAcwBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA=;Sosha1_v1;7;{8AB5DC96-597C-4CD9-AD77-F7838B8EDC33};YQBzAGkAbgBoAGEAQAB6AGUAdQBnAG0AYQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0A;Thu, 27 Aug 2009 21:36:53 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAYwBvAG4AcwBvAGwAZQBfAHAAcgBpAG4AdAA6ACAAYwBoAGEAbgBnAGUAIAB0AGgAZQAgAGYAdQBuAGMAdABpAG8AbgAgAGEAcABpACAAdABvACAAbQBhAGsAZQAgAGkAdAAgAGgAYQB2AGUAIABwAHIAaQBuAHQAawAgAHMAdAB5AGwAZQAgAGkAbgB0AGUAcgBmAGEAYwBlAA==
Content-class: urn:content-classes:message
Subject: RE: [PATCH] console_print: change the function api to make it have printk style interface
Date: Thu, 27 Aug 2009 14:36:53 -0700
x-cr-puzzleid: {8AB5DC96-597C-4CD9-AD77-F7838B8EDC33}
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA961C@exchange.ZeugmaSystems.local>
In-Reply-To: <alpine.LFD.2.01.0908271233580.3218@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] console_print: change the function api to make it have printk style interface
Thread-Index: AconTY4JWUpFDwijSlGlsPdrRWZqxwAENfCw
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <20090825172640.af8b9f58.randy.dunlap@oracle.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA93B4@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908271233580.3218@localhost.localdomain>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Looks ok to me, but I'm not going to apply it in late -rc, since it
>doesn't really fix any bug. Feel free to re-send after 2.6.31 is out,
or
>try to get it into one of the trees to be merged later.
>

Thanks Linus. I will resend the patch once 2.6.31 is out of the door.

Ani

