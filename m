Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYGEOIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYGEOIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYGEOHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:07:55 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:45702 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbYGEOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=do7yBlU/3uX50eiWV5QrQAyH/S+dhUAAzBqZQQpzccAZHALDIV+hs/01+XrPDPfWoe
         1W+zXE2OQY+9ymgg6lvB/a7srfJ3w3Y34+kimcS/yY23zp1defLk9eavYTjRA9NQrn0K
         Q3BVJu/0NUu+xf+/ULTxleOhCDL6ua+iAVjv8=
Message-ID: <c384c5ea0807050707q6e2cb93esfa3d8766c4660cf4@mail.gmail.com>
Date: Sat, 5 Jul 2008 16:07:49 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH -rt] [resend as inlined patch] {queue,schedule}_work_prio() allowing work priorities other than caller's priority
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, leon@sidebranch.com
In-Reply-To: <1215193280.9513.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486E271E.705@sidebranch.com>
	 <1215193280.9513.3.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Fri, Jul 4, 2008 at 7:41 PM, Daniel Walker <dwalker@mvista.com> wrote:
> Looks like you patch has line wrapped damage, and white space damage..
>
Thanks, I was unaware of the flowed text issue. Thought to had
configured Thunderbird correctly to not flow outgoing plaintext.

I have resend the patch using msmtp.

In the process, clearified the patch description, the patch itself is identical.

Regards,
-- 
Leon
