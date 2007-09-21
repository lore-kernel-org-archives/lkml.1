Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbXIUTap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbXIUTap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXIUTai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:30:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53057 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbXIUTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:30:38 -0400
Date: Fri, 21 Sep 2007 21:30:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Fordham <peter.fordham@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: fpu IO port reservation (arch/i386)
Message-ID: <20070921193035.GA16811@one.firstfloor.org>
References: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com> <Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl> <p73y7f07zuz.fsf@bingen.suse.de> <Pine.LNX.4.64N.0709211724470.2724@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0709211724470.2724@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  For the curious the details of all the hassle are reasonably well 
> described in the Intel's AP-578 application note.

Thanks. Ok it has to stay for for i386 then; although it would be in theory
possible to only reserve when the CPU is a real 386. For x86-64 it's
gone now.

-Andi
