Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYC0LJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYC0LJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYC0LJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:09:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1588 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbYC0LJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k3ED6GnnOrtb580b6nMBIZNO4+JCiJn3sRWGiUEHkB8RgZp2lc9+eT+MRAPzKGIf8hEK7nKik6oZMV7gVWkxeY3g25MqhIDNi0pSC72p1HrrU6hPIljzQTPTsLNwvcPoRoRb5AkH98Ia4mHnMCTgWs6kppaJKtz4tJrI2KiF58s=
Message-ID: <47EB8050.4010700@gmail.com>
Date: Thu, 27 Mar 2008 12:09:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org, wim@iguana.be,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin char driver for Blackfin on-chip OTP memory
 (v3)
References: <> <1206643758-9319-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1206643758-9319-1-git-send-email-cooloney@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu napsal(a):
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> initial char driver for otp memory
> (only read supported atm ... needs real examples/docs for write support)
> 
> v2-v3:
>  - fixup __initdata with __initconst, as we are heading for 2.6.26

OK, thanks.

> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

Will somebody pick the patch up (otherwise cc akpm or I might fwd it)?
