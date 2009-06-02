Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZFBLnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZFBLnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759097AbZFBLm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:42:57 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:48114 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbZFBLmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rXxaHMG4pLChpYW/fSJeJVXG0FGw8cb9Lrr+fSABGfO9j1DF1ucOX7k4HvmLu2pFHS
         aAO8/Ubj+N0pzGBJqRS7oaKBfVfuynmhV8YC7hTEo/PICSB7xowNf2aVz5LNhWV538wJ
         W7t2wS50KsaG0yjH9FCI5hYSwhFF6ERddiR/0=
MIME-Version: 1.0
In-Reply-To: <4A24F106.5040704@cam.ac.uk>
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	 <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com>
	 <20090601203348.GC7143@doriath.ww600.siemens.net>
	 <200906021010.49613.hs4233@mail.mn-solutions.de>
	 <1243930893.3192.62.camel@localhost.localdomain>
	 <bc64b4640906020129x4fe15e5en9d8e2cad1d86b236@mail.gmail.com>
	 <1243931809.3192.68.camel@localhost.localdomain>
	 <6097c490906020149j5d614064ied2a4bfebd13ddb0@mail.gmail.com>
	 <4A24F106.5040704@cam.ac.uk>
Date: Tue, 2 Jun 2009 15:42:55 +0400
Message-ID: <bc64b4640906020442o6f61a39fw2208302e91c56d69@mail.gmail.com>
Subject: Re: ?????: [PATCH 10/10] ieee802154: add at86rf230/rf231 spi driver
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: maxim@mox.ru, Marcel Holtmann <marcel@holtmann.org>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       linux-wireless@vger.kernel.org,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/2 Jonathan Cameron <jic23@cam.ac.uk>:
> Thank you to Dmitry and co for your work on this project, I'll be following
> your progress with interest (and when I have a sec adding support for the cc2420
> if no one else does it first ;)

We will be waiting with interest for these patches. We don't have the cc2420 hw
at hand, so we won't work on support for it in the foreseeble (1-3
moths :)) time.

-- 
With best wishes
Dmitry
