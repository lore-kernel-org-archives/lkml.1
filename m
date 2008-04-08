Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYDHUyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYDHUyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYDHUya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:54:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39797 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbYDHUy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:54:29 -0400
Message-ID: <47FBDB82.9000607@sgi.com>
Date: Tue, 08 Apr 2008 13:54:26 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
References: <20080408184301.651388000@polaris-admin.engr.sgi.com> <36ca99e90804081233x2daef177u52a169d5382094df@mail.gmail.com>
In-Reply-To: <36ca99e90804081233x2daef177u52a169d5382094df@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>>   * Cleanup usages of cpumask_scprintf in the following files and add
>>     another interface to use cpulist_scnprintf where appropriate.
> Great. Sometimes the simplest solution needs the longest way. ;-)
> 
> Thanks.
> Bert

I agree though sometimes "acceptance" is the hardest part... ;-)

Thanks,
Mike
