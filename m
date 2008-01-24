Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbYAXRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbYAXRG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbYAXRE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:04:27 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32869 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYAXREZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:04:25 -0500
Message-ID: <4798C511.8070305@davidnewall.com>
Date: Fri, 25 Jan 2008 03:34:17 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist>
In-Reply-To: <20080122160114.GB23277@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> But Linux kernel development is not driven by people producing hot air 
> about what they wish to see in the future, Linux kernel development is 
> driven by people sending patches.

Removal of code is not development.  It's the opposite of development.

At one stage iBCS2 support DID work.  Now it doesn't.  Now there's an
argument that the remaining infrastructure should be removed.  This is
the wrong direction to take.
