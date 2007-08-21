Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXHUVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXHUVlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXHUVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:41:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34543 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbXHUVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dbg5/ksg+XyhkwRhIg6ogCQmBwFX9etUF56C3rNDKrjse2NRsSAYGsb3DD5O1kzyfqgSI7ddAkFtf2+zBlAbYz40GKa99VtSCswgW/OMMtaWS6mxM8g/vvFxpsWe/Sx/AYngVIQ0Ti+hIZV+SBOO90KSFFdyTj35naDDpiRYzg0=
Message-ID: <6101e8c40708211441g2ae20412u877082eb611f595e@mail.gmail.com>
Date: Tue, 21 Aug 2007 23:41:10 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: RFC: drop support for gcc < 4.0
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jarek Poplawski" <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20070821173550.GC30705@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070821132038.GA22254@ff.dom.local>
	 <20070821093103.3c097d4a.randy.dunlap@oracle.com>
	 <20070821173550.GC30705@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I think it's bad idea, when removing support for gcc3.x, while some
people using debian 3.1 at now and under debian 3.1 the default
comiler is 3.3.5, when I good know or not!?
