Return-Path: <linux-kernel-owner+w=401wt.eu-S935480AbZLPWhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480AbZLPWhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935175AbZLPWhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:37:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935394AbZLPWhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:37:41 -0500
Message-ID: <4B29619E.3030200@gmail.com>
Date: Wed, 16 Dec 2009 23:39:26 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       eric.y.miao@gmail.com, mike@compulab.co.il,
       torvalds@linux-foundation.org, mjg@redhat.com, mingo@elte.hu
Subject: Re: [PATCH 05/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com>	 <3b8f4305c6acb257fbf227f19cb227450d6c7182.1260662995.git.re.emese@gmail.com> <1260917269.18578.0.camel@ted>
In-Reply-To: <1260917269.18578.0.camel@ted>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Mon, 2009-12-14 at 00:58 +0100, re.emese@gmail.com wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>>
>> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> 
> Applied to the backlight tree, thanks.
> 
> Richard

Thank you! Please note that this patch series contains a hunk that
constifies structure fields as well which raised some controversy
among other developer (see the address_space_operations sub-thread
for details). If you also don't feel comfortable with that change,
please let me know and I will resend the patches without that hunk.
--
Emese
 

