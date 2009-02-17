Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZBQOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZBQOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZBQOdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:33:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:45099 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZBQOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LZdDsZamCkPDKpl6H+9txutzu9qf6/vJo6rC6RnOuFcGzgFwsVQh1KSn3VVpY2+CaY
         68k9UrSDY+HLSJ+5VrHNvd1cgGC201KS2godLk3ns8MBe2f7uK5q433Exci5R81JCTlL
         JoVHKDy7m98IhM7v4KXIv/VdrJ8eJ25MncesA=
Date: Tue, 17 Feb 2009 09:32:51 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: dayu@datangmobile.cn
Cc: LeoLi@freescale.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
Message-ID: <20090217143251.GA1803@yoda.jdub.homelinux.org>
References: <D728AD1FA2543948B89DE29C5BF4CD0716AC2DDE@bjmail1.bj.datangmobile.com> <76C7F485-EF75-4B83-B673-564E6243C7C6@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76C7F485-EF75-4B83-B673-564E6243C7C6@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 08:12:33AM -0600, Kumar Gala wrote:
>
> On Feb 17, 2009, at 6:44 AM, <dayu@datangmobile.cn> <dayu@datangmobile.cn 
> > wrote:
>
>> From: Da Yu <dayu@datangmobile.cn>
>> Date: Tue, 17 Feb 2009 19:58:20 +0800
>> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC  
>> (2.6.23)
>>
>> Signed-off-by: Da Yu <dayu@datangmobile.cn>
>> ---
>
> Please provide a bit more description as to why this fixes the issue.

Including whether it still applies to mainline, since your topic seems
to indicate it's for 2.6.23.  That is pretty old by now.

josh
