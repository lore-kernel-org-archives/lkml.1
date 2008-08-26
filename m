Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYHZRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYHZRYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYHZRYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:24:16 -0400
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:48980 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753489AbYHZRYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:24:14 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 13:24:14 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 329168.2805.bm@omp109.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=QM4G0WLmgOD2yuVVMldaORW5aSeTXzMCI5wsArWXstPZzo/LyK2/xquLHooqtQ6YILC+Xoo//9hfR1/H18R253vxtnIMXXFV/UKNdy5zHQI6XVMUfaIoKtUPvl40DP8LmGw7Fq2qEflPuvvrxra8wvR3ghgqTXCSTi3l9UfKJfA=;
X-YMail-OSG: cfwid1gVM1kcbnI7bgb36Ng2GEOlFjPL083dbvsTUpExElOld53_M7991ezX9yudwNe1UtMiEsA5meMLLvPfpif5k9vBc7rAp22wXYELWOCGnVboW32BwQMQoloJxOzlgg--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 26 Aug 2008 10:18:49 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable after using ehci_info
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0808261036020.2493-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <518137.79296.qm@web45209.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Alan

> What I don't know is whether the problem is seen when
> you use only 
> the high-speed device.  Is it?

Yes. The problem is seen if I use only high speed device. 

>For some reason this "HC died" line doesn't
> appear in your previous 
> log.  I wonder why not?
It is becasue I have shown the log messages after "HC died".

I will add more debug messages as suggested, rebuild the kernel 
and let you know.

Thanks
Amruth p.v





      

