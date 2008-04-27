Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYD0IhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYD0IhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYD0IhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:37:10 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:47433 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYD0IhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:37:08 -0400
Message-ID: <4814377A.7090806@zoopnet.de>
Date: Sun, 27 Apr 2008 10:21:14 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org> <86802c440804261757h305e5abbs9d61f2fd4f40cc4f@mail.gmail.com>
In-Reply-To: <86802c440804261757h305e5abbs9d61f2fd4f40cc4f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu schrieb:
> On Sat, Apr 26, 2008 at 3:56 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>  Could someone please take a peek at
>>  http://bugzilla.kernel.org/show_bug.cgi?id=10508 ?
> 
> can you check if you can set up MTRR mapping in BIOS from Continuous
> to Discrete?

Unfortunately my BIOS offers no advanced settings at all. The only thing
I can change is the size of the video memory. But changing this has no
effect on the MTRRs.

Regards,
 Mika
