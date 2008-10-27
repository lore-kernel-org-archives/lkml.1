Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYJ0XGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYJ0XGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYJ0XGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:06:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:49124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYJ0XGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:06:43 -0400
Message-ID: <4906495B.1060506@kernel.org>
Date: Mon, 27 Oct 2008 16:06:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: bob.montgomery@hp.com
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] disable CPU side GART accesses
References: <1224107317.2215.238.camel@amd.troyhebe>	 <20081015234842.GA10999@elte.hu> <1225147341.2215.401.camel@amd.troyhebe>
In-Reply-To: <1225147341.2215.401.camel@amd.troyhebe>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Montgomery wrote:
> On Wed, 2008-10-15 at 23:48 +0000, Ingo Molnar wrote:
>> (Cc:-ed the GART folks.)
> 
> Are there any objections to this patch?  The problem has been reproduced
> in 2.6.18 and 2.6.27, so existing changes in the gart code have not
> addressed it. 

better to have someone with amd system + 8g ram + agp adapter to verify it...

YH
