Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbXGILZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbXGILZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXGILZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:25:46 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:50134 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbXGILZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:25:45 -0400
Date: Mon, 9 Jul 2007 13:25:36 +0200
From: DervishD <lkml@dervishd.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: cdparanoia not setting count and/or reply_len properly
Message-ID: <20070709112536.GA3015@DervishD>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <20070708103928.GA20349@DervishD> <4690DA1B.3010901@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4690DA1B.3010901@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Stefan :)

 * Stefan Richter <stefanr@s5r6.in-berlin.de> dixit:
> >     I don't know if cdparanoia should be fixed, but certainly the
> > warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way you
> > will have the message if something goes wrong and you want more info,
> > but in cases where the warning is harmless your log will be clean...
> > 
> >     Anyway, this message is not for make suggestions, but for asking for
> > information: why is this warning happening? naugthy cdparanoia? naughty
> > kernel? I'm a bit confused and I want to use my external DVD drive for
> > ripping from time to time, to "exercise" it...
> 
> This question is better asked at lsml.  (Therefore I'm quoting in full.)

    First time I hear about that list, sorry O:))) Thanks a lot for
forwarding, Stefan :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
