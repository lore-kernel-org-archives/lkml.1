Return-Path: <linux-kernel-owner+w=401wt.eu-S1030715AbXDZLvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715AbXDZLvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030751AbXDZLvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:51:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18858 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030715AbXDZLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I0IgAL2CdflbFlcPNGgHESVytyvy3wiyCsT8PjYenqbiAReK4h/nvXISi81hfs/pAY9ZP7nWn1/Xs8h17pFWHU3d9HwL43vYNuiCNEiRfxKVHCM6Euekea/hPREVDmev9TfC7p8KWhY7zb0KwXEa+C1vBx2AxNWJAKGTLqU+ylQ=
Message-ID: <46309142.2010907@googlemail.com>
Date: Thu, 26 Apr 2007 13:47:14 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
>
>
> - this has everything which is in 2.6.21.  Plus more!
>
> - a number of nasty bugs were fixed.  This should be (a lot) more stable
>   than 2.6.21-rc7-mm1.
>
>   

I get this warning here :


drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
'UCC_GETH' refer to undefined symbol 'UCC_FAST'


Regards,

Gabriel
