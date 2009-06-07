Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZFGMYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZFGMYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZFGMX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:23:59 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35339 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZFGMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fkgh+AvgC3rf/sAlL01gMMUDyPaKmwUBxT2u/QhOgL2cumJXw3ORR9Shu25OcM1Pqj
         LzJk4/OupVHtYDj8AtCcdL5Y5gYDltmyoZ3CLe982imwr1OnUnK8IWEDNRSXbnRgDrLX
         RExKnFN+mtHOYHj7MOyrMC4hWV8G0vliT/frI=
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1244370250.2907.1.camel@johannes.local>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
	 <1244326943.12159.5.camel@localhost>  <1244334102.16810.3.camel@localhost>
	 <1244367815.26071.4.camel@johannes.local>
	 <1244368455.22643.4.camel@localhost>
	 <1244370250.2907.1.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 15:23:42 +0300
Message-Id: <1244377422.15333.6.camel@nadejda-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 12:24 +0200, Johannes Berg wrote:
> On Sun, 2009-06-07 at 12:54 +0300, Maxim Levitsky wrote:
> 
> > Fine, like I expected, but still, I guess there is some 'loader' in
> > eeprom?
> 
> Yes.
> 
> > If there were a documentation too.
> > Isn't it possible to publish it?
> > 
> > This firmware contains so many 'magic' registers.
> 
> There is some, but it's not public. We can try to document some when we
> replace the magic values by constants.
> 
> johannes

Exactly.

If you could make it public.....

I am taking even not especially about this device, but 
about ath5k AR2425.

My aspire one has several very nasty bugs, and little hope they will be
fixed, and I blame no one for that, developers are busy, and  load is
high.

But on the other hand, chances I fix them are low, I already read whole
ath5k drivers, and without documentation it is hard to see what it going
on.

The only way out I see, it to load windows driver in ndiswrapper, pray
that it will work, and then use mmiotrace to see what is done
differently. I really hate going this way.


Best regards,
	Maxim Levitsky



