Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbXFAGK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbXFAGK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXFAGKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:10:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXFAGKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:10:46 -0400
Message-ID: <465FB862.207@zytor.com>
Date: Thu, 31 May 2007 23:10:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <28278.1180675923@turing-police.cc.vt.edu>
In-Reply-To: <28278.1180675923@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 31 May 2007 19:09:10 PDT, akpm@linux-foundation.org said:
> 
>> +If a person was not directly involved in the preparation or handling of a
>> +patch but wishes to signify and record their approval of it then they can
>> +arrange to have an Acked-by: line added to the patch's changelog.
>> +
>> +Acked-by: is often used by the maintainer of the affected code when that
>> +maintainer neither wrote, merged nor forwarded the patch themselves.
> 
> Do we want to add verbiage saying that an Acked-By: is also useful when it
> comes from somebody (likely the original reporter) who has actually tested the
> patch?

I'd rather see a Tested-By: for that.

There is a difference between a maintainer ack and a tester ok.

	-hpa
