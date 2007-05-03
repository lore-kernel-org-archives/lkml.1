Return-Path: <linux-kernel-owner+w=401wt.eu-S1767540AbXECRis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767540AbXECRis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767537AbXECRis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:38:48 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:5830 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376267AbXECRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ihYjLeA8/rud5A5CdI/aJdJ8XZO7dQHisLkmlVnDQBhEiQjuzQabHXHd3T2sEKaSYDHuQW1fbZpeyrZC2doZSZ+VZhKuVZEFdxdi1iNvFSfQDwHye/uJHTHpXNPFVFkBDM2HdDsPg7I9+5u3h5E0/fuHKPVmzZB5YGs/hSXc52w=
Message-ID: <463A1E1B.9090509@gmail.com>
Date: Thu, 03 May 2007 21:38:35 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Execute in place
References: <200705030211.36293.a1426z@gawab.com> <46398FCF.80100@gmail.com> <200705031433.09364.a1426z@gawab.com>
In-Reply-To: <200705031433.09364.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Dmitry Krivoschekov wrote:
>> Al Boldi wrote:
>>> Now, if there were only an easy way to make tmpfs persistent?
>> It would be not a tmpfs (*temporary* fs)then,
>
> Isn't everything really just temporary?

Would  you like to talk about this?
Not with me, I'm not a psychoanalyst :)

>
>> but something like this
>>
>> http://pramfs.sourceforge.net/
>
> Thanks a lot, but this seems to rely on a non-volatile RAM.

No, it relies on a battery-backed normal RAM, which of course
may be considered as non-volatile.


Thanks,
Dmitry
