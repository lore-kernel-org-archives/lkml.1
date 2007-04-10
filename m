Return-Path: <linux-kernel-owner+w=401wt.eu-S1030611AbXDJWbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030611AbXDJWbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXDJWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:31:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40408 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030611AbXDJWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:30:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Account for module percpu space separately from kernel percpu
References: <461BC4B6.9060006@goop.org>
	<m1abxfyiwk.fsf@ebiederm.dsl.xmission.com> <461C0D70.50005@goop.org>
Date: Tue, 10 Apr 2007 16:30:03 -0600
In-Reply-To: <461C0D70.50005@goop.org> (Jeremy Fitzhardinge's message of "Tue,
	10 Apr 2007 15:19:28 -0700")
Message-ID: <m1tzvnx3pw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> I think I have already done this but in case I haven't.
>> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> I see any problems there.
>>   
> ^don't?

Yep.  I did not see any problems with the patch.

Eric

