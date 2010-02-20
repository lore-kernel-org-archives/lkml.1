Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0BTUpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 15:45:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:55661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab0BTUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 15:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d9i5hzmE6Fg4I8XPDSASon/p17uurvAo0RWE20Uck6TeDvfCEwyczqj9vLkP+Sy3kt
         A1zH9a2GHlshquNNdMXunA+Smn8midJGdXrsDg+8oyP2Ub1QweDcYkAjTDE5hufxg+Qe
         FLwo+tCr+U2ezUeeBRTRCr0dQ2f5lVyOTAois=
Subject: Re: [PATCH 0/14 V9] Work to enable SmartMedia/xD support in mtd
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1266697630.4152.0.camel@maxim-laptop>
References: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
	 <1266697630.4152.0.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 22:45:01 +0200
Message-Id: <1266698701.3178.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 22:27 +0200, Maxim Levitsky wrote:
> On Wed, 2010-02-17 at 23:49 +0200, Maxim Levitsky wrote: 
> > This is slightly updated version of my patchset.
> > Now I can tell you for sure that hotplug works.
> > It was used/abused for long time.
> > I did some changes in richoh card reader driver, to work better after resume
> > and renamed it to r852.
> > 
> > I kindly ask you to merge this patchset to 2.6.34.
> > If I/users find other bugs they can be addressed by follow up patches.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > 
> Should I expect at least some response on that?
> Or not?

Since you put me to CC, I answer: not from me, I have no time at all to
look at this closely.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

