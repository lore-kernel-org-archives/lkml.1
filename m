Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYCGAW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYCGAW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbYCGAWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:22:18 -0500
Received: from gw.goop.org ([64.81.55.164]:48634 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134AbYCGAWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:22:17 -0500
Message-ID: <47D0895C.5070901@goop.org>
Date: Thu, 06 Mar 2008 16:16:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr>
In-Reply-To: <47CE6F66.7020004@netone.net.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> When .rc3 released I got this error message at kernel compile stage. 
> And now, one more time, I got the same error message. It seems, still 
> this compile problem couldn't fixed in .rc4. My config is attached. 
> I'm using Kubuntu 7.10 with the latest updates.
>
>
> Makefile:514: /usr/src/linux-2.6.25-rc4/arch/xen/Makefile: No such 
> file or directory
> make[1]: *** No rule to make target 
> `/usr/src/linux-2.6.25-rc4/arch/xen/Makefile'.  Stop.
> make: *** [conf.vars] Error 2 

That doesn't make much sense.  Are you compiling with ARCH=xen or 
something?  I can't reproduce it here with your .config.

    J
