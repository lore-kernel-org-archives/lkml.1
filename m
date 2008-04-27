Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYD0FKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYD0FKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYD0FKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:10:47 -0400
Received: from gw.goop.org ([64.81.55.164]:41197 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYD0FKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:10:46 -0400
Message-ID: <48140ACF.4000500@goop.org>
Date: Sat, 26 Apr 2008 22:10:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Gerhard Mack <gmack@innerfire.net>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25] compat VDSO option not disabling
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz> <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net>
In-Reply-To: <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> I havn't enabled compat VDSO at the kernel command line or otherwise.  
> Something broke with this option. 
>   

Yes, you might be on to something.  I think I've been seeing that 
message when I wouldn't expect to.  I'll double-check.  Could you send 
your complete dmesg output?

Thanks,
    J
