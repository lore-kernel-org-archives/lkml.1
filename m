Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZBEHRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZBEHRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZBEHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:17:26 -0500
Received: from gw.goop.org ([64.81.55.164]:38779 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEHR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:17:26 -0500
Message-ID: <498A9284.8050805@goop.org>
Date: Wed, 04 Feb 2009 23:17:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen: setup percpu data pointers
References: <49876BD3.5070804@goop.org> <498A8738.9050200@gmail.com> <498A8C05.30704@kernel.org>
In-Reply-To: <498A8C05.30704@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Tejun Heo wrote:
>   
>> Applied 1-3 to #tj-percpu with trivial modification on #2 (will reply
>> to the message).
>>     
>
> Oh... hpa already merged them into x86/paravirt.  I'll just pull
> x86/paravirt into core/percpu because the first patch needs to be in
> core/percpu to keep xen working.
>
> hpa, can you please take the other xen patch[1] into x86/paravirt too?
> So that I can receive it via you?

Looks like its already there.

    J
