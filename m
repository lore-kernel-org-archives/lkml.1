Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZLJWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZLJWmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbZLJWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:42:51 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51447 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762003AbZLJWmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=U8yeAesAE6dbNID4gC4kZYZdxQjDMWjvrdTQq/iS0IhbWzaY2PcIzsJR5Z5U9CSHcj
         3ITKNb2FHXzhVEFb54eLXrLgRRJU5EU87flPkNRNDBfeESytKYb38sUGvpG8XMLYRbyC
         722qy3S10cHVY7bFiMXno60it1P7P3BQNFh8U=
MIME-Version: 1.0
In-Reply-To: <4B2169A8.5080503@caviumnetworks.com>
References: <4B212EEC.3060808@caviumnetworks.com> <1260466101-17545-5-git-send-email-ddaney@caviumnetworks.com> 
	<8bd0f97a0912101333x2ba210d8ib1936bffa0ef2d7b@mail.gmail.com> 
	<4B2169A8.5080503@caviumnetworks.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 10 Dec 2009 17:42:37 -0500
Message-ID: <8bd0f97a0912101442kfeb360cvf529321679ff1b2e@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 5/5] blackfin: Convert BUG() to use 
	unreachable()
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 16:35, David Daney wrote:
> Mike Frysinger wrote:
>> On Thu, Dec 10, 2009 at 12:28, David Daney wrote:
>>> Use the new unreachable() macro instead of for(;;);
>>
>> sorry, i guess i missed this back in Sept.  change looks fine to me
>> (i'll test it later when finishing putting together other patches).
>> you want me to push though my queue ?  doesnt matter to me.
>
> Yes, if you test it and are happy with it.  I have no queue and plan no
> further action.

rgr
-mike
