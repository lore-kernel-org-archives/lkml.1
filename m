Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbXHVLKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbXHVLKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 07:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbXHVLKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 07:10:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:10807 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbXHVLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 07:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cPN685tJsjTrfJgxXS6QrUD3u/SycLcsUl9BGWNeXbrjFYFGD1ooth8+Zo+9AOGoYq3uIJ5XNjk+MnQ2il+I2nPHpGHrLkFrkXJ+obvogy2STocgHyfRL86i3VfQq6NxBmjZnCI/WdKzouQ8meLYoPcAXJVxvvVGwuPZaBA00dk=
Message-ID: <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
Date: Wed, 22 Aug 2007 13:10:44 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20070822083844.%N@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822083844.%N@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On 22/08/07, Willy Tarreau <w@1wt.eu> wrote:
> This is the start of the review cycle for the stable 2.6.20.17
> kernel release. This version catches up with 2.6.22.4, and 58
> patches will be posted as a response to this message.
>
> The following security issues are solved :
>   CVE-2007-3105
>   CVE-2007-3848
>   CVE-2007-3851
>
> The rolled up patch can be found here :
>    ftp.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.20.17-rc1.gz
>
> Responses should be made by August 24, 2007, 19:00:00 UTC. Anything
> received after that time might be too late.

I got a problem with SELinux
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/stable-config

rpm -qa selinux-policy*
selinux-policy-devel-2.6.4-33.fc7
selinux-policy-2.6.4-33.fc7
selinux-policy-targeted-2.6.4-33.fc7

I didn't tested 2.6.20.* since 2.6.20 release so it might take some
time to figure out.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
