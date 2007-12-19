Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbXLSAY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbXLSAY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXLSAYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:24:52 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4960 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbXLSAYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:24:51 -0500
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 19:24:50 EST
Message-ID: <4768618D.1050400@xs4all.nl>
Date: Wed, 19 Dec 2007 01:10:53 +0100
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: howto get a melodic system beep?
References: <4765A5ED.60605@t-online.de>
In-Reply-To: <4765A5ED.60605@t-online.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote on 16-12-07 23:25:
> Hi folks,
> 
> Is there a way to replace the system beep by something more
> melodic?
> 
> I remember some 10 years ago there was a patch for the kernel
> to call an external "beep daemon" playing an audio file instead
> (no kidding). But it never worked very well. Sometimes there
> was a huge delay, and some programs were not very nice to the
> system beep.
> 
> My X-mas wish would be to get an improvement here.

I think the uinput module can handle this.  There's an
example floating around somewhere.

bjd
