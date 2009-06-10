Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZFJLba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZFJLba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZFJLbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:31:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:48268 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbZFJLbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tL1o9k8nriv3p+TlIH1f423NQpn8bHP7pYSPH6mSX3KcOqVzC//EGrNN8Ll1rJmgRK
         BfxsU7LVmDqubocnAV/6N+whFGvSUHLIEldQmB7f3+I71z0I9Tz7mKXTjyt6/a8ortKd
         zvxFmwERfusDAmtM9mHeLdFSRI+q7O6tPRgTE=
MIME-Version: 1.0
In-Reply-To: <b9df5fa10905261949j3eb4dc9ft321dba3c46c335db@mail.gmail.com>
References: <b9df5fa10905251820l3783327ek4f6b7014aa167690@mail.gmail.com>
	 <86802c440905251911h6f6c146eo4c30d306ac8d17d8@mail.gmail.com>
	 <b9df5fa10905261949j3eb4dc9ft321dba3c46c335db@mail.gmail.com>
Date: Wed, 10 Jun 2009 17:24:10 +0600
Message-ID: <b9df5fa10906100424h98862a8l32951906d06454fb@mail.gmail.com>
Subject: Re: [PATCH] v2: x86,APIC: Detect lapic_is_integrated() once - use on 
	and on
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: yhlu.kernel@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       macro@linux-mips.org, Cyrill Gorcunov <gorcunov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas and everyone, would you please take a look at this
patch and comment ? I think Thomas was agreed with this one. Is there
anything that i couldn't deliver? If i'm wrong please notice thus i
can fix myself.

Thanks,
Rakib
