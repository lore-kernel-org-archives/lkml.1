Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYI2Ikg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYI2Ikg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYI2Ik1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:40:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:31306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYI2IkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dOZxOZMAQV8EhUk6046opOjQyWuCyvZuOjWdcX/DI5AL0MepV/mCgCoMry938I0Xsw
         q62BJ9oL24bnMcc5ymmbDMG6Cfk8P0MBZNnnNfxF7PpQRskT1xYjKygJTzHgtY0azE4t
         /9x4LxG+uoN8z/4eF54JGL7DZY5mhAS+lI/ks=
Message-ID: <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:40:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andres Freund" <andres@anarazel.de>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809291027.50453.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809251511.20132.andres@anarazel.de>
	 <1222441955.3798.13.camel@johannes.berg>
	 <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
	 <200809291027.50453.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:27 AM, Andres Freund <andres@anarazel.de> wrote:
> Hi,
>
> On Saturday 27 September 2008, Tomas Winkler wrote in "Re: bad DMAR
> interaction with iwlagn and SATA":
>> Meanwhile it all reported bugs in this case points to 64 bit
>> installations, I'll give it more testing
> Would it help to test on 32bit? I have some dissk with 32bit system installed
> lying around somewhere...

It would help to try to isolate this as 64 bit issue

> Any other patches to try?

I've posted few patches lately to address some RX buffers issues you
may to try those. Not sure it will help though.
http://marc.info/?l=linux-wireless&m=122241327108723&w=2
http://marc.info/?l=linux-wireless&m=122241327208729&w=2

Thanks
Tomas
