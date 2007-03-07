Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXCGNDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXCGNDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965261AbXCGNDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:03:42 -0500
Received: from khc.piap.pl ([195.187.100.11]:44980 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965157AbXCGNDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:03:41 -0500
To: "Oleksiy Kebkal" <kebkal@gmail.com>
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	<m3bqj6jebt.fsf@maximus.localdomain>
	<200703061824.08834.rgetz@blackfin.uclinux.org>
	<57354eff0703070454u24e97309j55ec9de584ced71e@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 07 Mar 2007 14:03:38 +0100
In-Reply-To: <57354eff0703070454u24e97309j55ec9de584ced71e@mail.gmail.com> (Oleksiy Kebkal's message of "Wed, 7 Mar 2007 13:54:28 +0100")
Message-ID: <m3649durx1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Oleksiy Kebkal" <kebkal@gmail.com> writes:

> May be it would be good idea to develop some tty control driver which
> provides a
> possibility to change default setting of the drivers?

If there is a real need for it (such as a real existing device)...
then sure (it wouldn't be a "default setting" anymore, of course).
-- 
Krzysztof Halasa
