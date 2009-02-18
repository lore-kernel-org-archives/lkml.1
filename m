Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZBRIpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZBRIpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZBRIpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:45:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZBRIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:45:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cT2r4BifTC/tbp8MbYY1QdKV4a3BvvvVENJ5keOaLQ0iAoJxQ+PcvAgzhy8ozjNXGS
         PQ/7LAsJn3xK9+jqQSzAdvtj7ywPBneGH1NwmHvyIGdiq+fGGxiBPACu7BeB2yywPljC
         70B5spyO9Vj+VfNn0qTKkEhV/wkJ3sGMs3gCY=
Message-ID: <499BCAB1.6060002@gmail.com>
Date: Wed, 18 Feb 2009 09:45:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090208 SUSE/3.0b1-7.1 Thunderbird/3.0b2pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, x86@kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>	<499B465D.9080502@gmail.com> <20090217153136.a407c776.akpm@linux-foundation.org>
In-Reply-To: <20090217153136.a407c776.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.2.2009 00:31, Andrew Morton wrote:
> On Wed, 18 Feb 2009 00:21:01 +0100
> Jiri Slaby<jirislaby@gmail.com>  wrote:
>
>> I'm getting the page fault below everytime during bootup.
>
> It'd be useful to know if bare linux-next does the same thing, please.

Not present at d6b658c (which is one from the mmotm), so this is pure 
-mm thing. Something between 2009-02-14-00-49 and this one.
