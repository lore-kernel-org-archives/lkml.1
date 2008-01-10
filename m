Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbYAJWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbYAJWxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYAJWxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:53:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:27966 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605AbYAJWxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VFHrGPmQ8PCEAQ4j4ABESroEquQEp3KuDRAE2Zz/U4EKxcmyyUG3dqDDye5YyAg4q6OjcrdpHmI7RWn+PM7uN0yxjMkoqv6kEHzeeulN3zsLJWb9+nvWyP/IR+6N8WO5btCnFQWmBQFzD0yx2IdsO7KblsxGnvIm2a5UVK8YZkg=
Message-ID: <e85b9d30801101453k21c60f81v1975cde6a8d5ed52@mail.gmail.com>
Date: Thu, 10 Jan 2008 23:53:16 +0100
From: Matthew <jackdachef@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ed Tomlinson" <edt@aei.ca>
In-Reply-To: <47869C93.2060308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>
	 <47868B6D.6030208@zytor.com>
	 <e85b9d30801101352hf66826eqe436e61310c96f14@mail.gmail.com>
	 <478694CB.4000306@zytor.com>
	 <e85b9d30801101428s1c760cb1i5ee415738dffb90f@mail.gmail.com>
	 <47869C93.2060308@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just managed to reproduce the bug in simulation.  I believe we should
> be able to resolve this.

That's great news! Keep up the good work :)

I hope that you guys'll be able to do so since it (indirectly) more or
less leads to data corruption (at least with thunderbird-bin &
firefox-bin -> both profile directories didn't work after the crash
anymore == data loss)
if I didn't have a backup aside they would have been lost ...

>         -hpa
>

Mat
