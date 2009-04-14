Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZDNVGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZDNVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZDNVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:06:37 -0400
Received: from main.gmane.org ([80.91.229.2]:47080 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbZDNVGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:06:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] radeon_cp: use request_firmware
Date: Tue, 14 Apr 2009 17:06:16 -0400
Message-ID: <49E4FAC8.1000804@tmr.com>
References: <1239640067.3237.4.camel@ht.satnam>	<1239647163.18110.150.camel@deadeye.i.decadent.org.uk>	<1239684881.3033.11.camel@ht.satnam>	<20090414142618.GY3051@decadent.org.uk> <m3bpqzuw50.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-70-109-119-176.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 SeaMonkey/1.1.15
In-Reply-To: <m3bpqzuw50.fsf@intrepid.localdomain>
Cc: dri-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
> 
>> I don't copy Signed-off-by if I make significant changes as the original
>> author should not be held responsible for any errors.  I'll be happy to
>> ask for your S-o-b before submitting a patch based on your work in future.
> 
> I think we should never include the original SOB if there was _any_
> change. SOB is not credits, it's a signature. If someone takes my patch
> and changes it, I want my SOB line removed unless I re-sign the modified
> patch.
> 
> We may invent some other Based-on-patch-by: etc. tag if really
> necessary, but the signature is a different thing.

Given that this is the 2nd or 3rd instance of someone feeling that their code 
has been used without credit, that may be a good idea. I certainly can see the 
point, having had a significant effort of mine lightly patched and then given to 
FSF without my name on it.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

