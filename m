Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZLNWpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZLNWpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZLNWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:45:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125AbZLNWpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:45:22 -0500
Message-ID: <4B26C074.9080801@gmail.com>
Date: Mon, 14 Dec 2009 23:47:16 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 05/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac
 v2
References: <cover.1260663003.git.re.emese@gmail.com> <2218084c294878ee335de04178d4c0b93167e248.1260663003.git.re.emese@gmail.com> <20091214051745.GG5114@elf.ucw.cz>
In-Reply-To: <20091214051745.GG5114@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-12-14 01:00:21, re.emese@gmail.com wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>>
>> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> 
> It definitely needs an explanation, and it has none.

Sorry, you are right, I am just new to git. The next series
will include the explanation.
--
Emese



