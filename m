Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbXJZBky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbXJZBky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXJZBkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:40:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:37980 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbXJZBko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Bk4ggvmvS+h6jsEnO6ejzanguWSZCh6gyCZj1FmbQJdXNpy2ZbgkkRNpTflFl/3yt9ieG6Wqey64sMdPBA4L+Ev2v99sOubhKlBfn81qFawdMXDgifD9E5CTz6G+AHF2RMDDc2gNtTmK6Z501XWJQuQizlbJU0U/TDu1f2D2IpA=
Message-ID: <47214593.1080102@gmail.com>
Date: Fri, 26 Oct 2007 10:40:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Steen Eugen Poulsen <sep@lix-world.net>
CC: Andrew Morton <akpm@linux-foundation.org>, lists@dusted.dk,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       bruce.allen@aei.mpg.de
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
References: <56020.194.255.108.253.1192004925.squirrel@root.dusted.dk> <20071012174153.69556b32.akpm@linux-foundation.org> <47105C53.7040603@lix-world.net> <471DC52B.20802@gmail.com> <471F2647.4030304@lix-world.net>
In-Reply-To: <471F2647.4030304@lix-world.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[please don't drop cc.  restored]

Steen Eugen Poulsen wrote:
> Tejun Heo skrev:
>> All these are caused by smartd.  Updating should fix the problem.
> 
> Okay, but there is no newer smartd than what I'm using. (5.37)

Bruce?  Original thread can be read from...

http://thread.gmane.org/gmane.linux.kernel/588972

-- 
tejun
