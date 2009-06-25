Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZFYIJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZFYIJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZFYII7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:08:59 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:7901
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751324AbZFYII6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:08:58 -0400
Message-ID: <4A43309A.3060306@panasas.com>
Date: Thu, 25 Jun 2009 11:08:58 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>	 <4A3F4448.30502@panasas.com>	 <20090625135901.a028512d.sfr@canb.auug.org.au>	 <4A432DD4.3010905@panasas.com> <6599ad830906250106q2807c72ci21e95b02448ec4f7@mail.gmail.com>
In-Reply-To: <6599ad830906250106q2807c72ci21e95b02448ec4f7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 08:09:01.0266 (UTC) FILETIME=[32B36320:01C9F56C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 11:06 AM, Paul Menage wrote:
> On Thu, Jun 25, 2009 at 12:57 AM, Boaz Harrosh<bharrosh@panasas.com> wrote:
>> Paul? we did not receive any feedback from you
> 
> I split it out into two patches and sent them about an hour ago. (One
> for mmu_context.h sent to Rusty and one for the other two fixes, sent
> to Linus)
> 
> Paul

Thanks ... :-)

Boaz
