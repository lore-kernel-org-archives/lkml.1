Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZDTBUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZDTBUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZDTBUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:20:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58451 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZDTBUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:20:12 -0400
Message-ID: <49EBCDB0.7000505@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 10:19:44 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RESEND][PATCH -tip 0/3] x86, mce: re-implement options for corrected
 errors
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> > * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> > 
>> >> Hi Ingo,
>> >>
>> >> Sorry, could you drop patch 1/3 and 3/3 from your -tip tree? Andi 
>> >> and I discussed some and agreed disabling CMCI need to be done in 
>> >> different way (at least parameter name).
> > 
> > Could you please send a patch that changes the parameter name?

I'm going to post three patches from now, heading two for revert
and last one for re-implement.


Thanks,
H.Seto


