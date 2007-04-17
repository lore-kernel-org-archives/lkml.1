Return-Path: <linux-kernel-owner+w=401wt.eu-S1031275AbXDQV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031275AbXDQV66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031267AbXDQV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:58:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39455 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031269AbXDQV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:58:55 -0400
Date: Tue, 17 Apr 2007 22:58:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Andi Kleen <andi@firstfloor.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070417225815.000b0fdb@the-village.bc.nu>
In-Reply-To: <20070417211653.GB11944@one.firstfloor.org>
References: <20070417181016.GA10903@one.firstfloor.org>
	<657751.18080.qm@web36614.mail.mud.yahoo.com>
	<20070417211653.GB11944@one.firstfloor.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But easy to use security is probably better than complicated security
> because normal people will more likely use it.

Easy to use security is only better if it *works*, and preferably its
excessively secure. Ineffective security is actually worse than no
security.

Real world examples include people using RFID badges thinking they are
secure so removing the use of the conventional key in door lock and
people using WEP wireless security so running no encryption or other
security on their wireless. Several of whom if statements are to believed
then found themselves being sued by the music industry because their IP
was used for file sharing.

Bad security is dangerous, really dangerous.


I'm not sure if AppArmor can be made good security for the general case,
but it is a model that works in the limited http environment
(eg .htaccess) and is something people can play with and hack on and may
be possible to configure to be very secure.

Alan
