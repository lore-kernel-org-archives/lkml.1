Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYD2BYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYD2BYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYD2BYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:24:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:32876 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYD2BYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pio2O5nhltS+iLStmMsebM7x099IkwK9nrdGTq8zo5iwzwSZf0HaJhcTT3hGtvfFTt434zPWLmt2zVvi36/M2GNrbZJZI98RKm8wwLjS6AeATZAU74M5JAHOXDYhpFOFjtPJQtytht5UzB0Z9y426cBaVgEbSs/3Vjkd8VPviys=
Message-ID: <481678C6.7050400@googlemail.com>
Date: Tue, 29 Apr 2008 03:24:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Gabriel C <crazy@frugalware.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
References: <4815EEB4.2060509@frugalware.org> <alpine.DEB.0.82.0804282016440.5277@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0804282016440.5277@skynet.skynet.ie>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Mon, 28 Apr 2008, Gabriel C wrote:
> 
>> Hello ,
>>
>> are there any plans to add G33 / Q33 / Q35 chipsets support for the intelfb driver ?
>> Is this driver still maintained ?
>>
>> ( I'm not really sure who maintains this driver so I've add peoples to CC I saw worked on it ,
>> I've also added Wang Zhenyu to CC while he added this support for AGP )
>>
> 
> Intel fb is unmaintained (well I've done trivial fixes in the past), and 
> I'd rather not add new chipset support to it.
> 
> We are working (RH and Intel) on a new kernel modesetting layer which will 
> allow fbs integrated with proper memory management and support all intel 
> hw, 

Good news :)

Are there any patch(es) / git tree one could try out ?

> 
> The main problem with intelfb is it trips up the userspace X drivers a lot 
> and generally break things..

Really ? I didn't knew that. 

> 
> Dave.


Gabriel
