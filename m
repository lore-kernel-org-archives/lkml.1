Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZHTIwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZHTIwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZHTIwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:52:02 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54486 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZHTIwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gGgDCvbXdUfngjui1ibcT5usHK80Yb1Tbm//pNEtNi2ygDqvCm5S0cU58QAsVpJN0Y
         zpDYI64HI66LXW4RcmsY2+6wsv9iuw6ixQZiMweu5NRSANHHo6zzwqNshYrGiOMPjQJ1
         S8HjFzJS3aafKisBz0cL9wO/kQtYVCql8rk9A=
MIME-Version: 1.0
In-Reply-To: <ADSuNT6McuD.A.fc.7NIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <ADSuNT6McuD.A.fc.7NIjKB@chimera>
Date: Thu, 20 Aug 2009 10:51:48 +0200
Message-ID: <25e057c00908200151i472fa3cem6da814e7115e1ea7@mail.gmail.com>
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
From: roel kluin <roel.kluin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
> Subject         : Libertas: Association request to the driver failed
> Submitter       : Daniel Mack <daniel@caiaq.de>
> Date            : 2009-08-07 19:11 (13 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
> References      : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
> Handled-By      : Roel Kluin <roel.kluin@gmail.com>

I think this should be fixed with patch of Dan Williams found here:

http://lkml.org/lkml/2009/8/12/299

Roel
