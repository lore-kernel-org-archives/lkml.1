Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZDUUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZDUUBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZDUUBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:01:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZDUUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ex0W7hVVaZpySZbhhcN4lPiK6eXUQIlt8O4z54xiMct0xwehNBSbvfFB8pAMSo3tAs
         LEyr1aW+swBSfqhYnNUEs844r2MU7NIHkmbQ4lHYg3lWu+jZnN9EiGt735m9oTLDbdhv
         7xUyMc/MlOwnx40zGgrXCAaiBB8X7ITLCn+/4=
Message-ID: <49EE25FB.9050503@gmail.com>
Date: Tue, 21 Apr 2009 23:00:59 +0300
From: Aioanei Rares <krnl.list@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: 2.6.29.1: Pid: 2831, comm: nfsd Not tainted 2.6.29.1 #4
References: <alpine.DEB.2.00.0904211202590.10241@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0904211202590.10241@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:



> Hello,
>
> This has been happening with 2.6.28.(x) and now 2.6.29.(x), can anyone 
> suggest the possible root cause of this problem, re: the nfsd page 
> allocation
> failures:
>


<snip>

Yes, it happened to me too on a Debian unstable machine with more than 
one kernel, starting with 2.6.28 until now. I have a feeling it's a 
Debian-specific problem rather than a kernel one.
