Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbZL2W6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbZL2W6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZL2W6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:58:36 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53417 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbZL2W6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:58:36 -0500
X-Sasl-enc: BDUFncR59h6omkVnvbBw15OlYanWqMUqyi7Lm0U8pJS+ 1262127514
Date: Tue, 29 Dec 2009 20:58:31 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #14942] gkrellm no longer shows all the temperatures on
 thinkpad x60
Message-ID: <20091229225831.GA13358@khazad-dum.debian.net>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
 <NJVdobuNFNK.A.MHG.BnhOLB@chimera>
 <20091229181356.GA30466@khazad-dum.debian.net>
 <200912292257.55961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912292257.55961.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14942
> > > Subject		: gkrellm no longer shows all the temperatures on thinkpad x60
> > > Submitter	: Pavel Machek <pavel@ucw.cz>
> > > Date		: 2009-12-27 21:57 (3 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126195107005565&w=4
> > > Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > 
> > Patch already in acpi-test, waiting push to mainline.
> 
> Great, thanks for the update.
> 
> Is there a link to the patch so that I can put it into the bug entry?

http://patchwork.kernel.org/patch/69809/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
