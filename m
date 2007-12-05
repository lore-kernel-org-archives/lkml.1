Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXLEDRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXLEDRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLEDR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:17:26 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:46976
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750954AbXLEDRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:17:25 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/3] RT balance v7a
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 21:55:23 -0500
Message-ID: <20071205025137.4494.18683.stgit@novell1.haskins.net>
In-Reply-To: <20071204212705.GA10360@elte.hu>
References: <20071204212705.GA10360@elte.hu>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Dec 4, 2007 at  4:27 PM, in message <20071204212705.GA10360@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> Ingo,
>> 
>> This series applies on GIT commit 
>> 2254c2e0184c603f92fc9b81016ff4bb53da622d (2.6.24-rc4 (ish) git HEAD)
> 
> please post patches against sched-devel.git - it has part of your 
> previous patches included already, plus some cleanups i did to them, so 
> this series of yours wont apply. sched-devel.git is at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
Hi Ingo,
  I have rebased to your sched-devel.git.  You were right, most of the patches
  were already there (1-20, in fact), so there remain only the last three.
  These constitute the "cpupri" moniker in Steven's testing.  Let me know if
  you have any questions.  Comments/review by anyone are of course welcome.

Regards,
-Greg

