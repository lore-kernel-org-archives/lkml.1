Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZEZH1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZEZH1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZEZH05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:26:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:24150 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZEZH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lQTOOmfFppliOAoFb5q/9NhtwAkx5Q2M8SH5UowducaZ0OBTv6HHUSvqzj9kgmMZI6
         Pt7hZkS/d+j8WY8kwPCU+SeMqTMx2FnO9W5V2DK5fCa88JHb/E0vQqnJeY+CcLlX8cr0
         IFUv2J/3Xf+ZVl4L4hTdmswqs/5Ek9W5NG1Hw=
MIME-Version: 1.0
In-Reply-To: <f24d23310905252256h74d609d9l7e23b1cdc0a240c6@mail.gmail.com>
References: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
	 <49b7c2350905251445n14397b82yc993f1a86d715d4d@mail.gmail.com>
	 <f24d23310905252256h74d609d9l7e23b1cdc0a240c6@mail.gmail.com>
Date: Tue, 26 May 2009 16:26:56 +0900
Message-ID: <49b7c2350905260026h95a229bse4b1f253601a40c8@mail.gmail.com>
Subject: Re: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
From: GeunSik Lim <leemgs1@gmail.com>
To: debian developer <debiandev@gmail.com>
Cc: linux kernel <kernelnewbies@nl.linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 2:56 PM, debian developer <debiandev@gmail.com> wrote:
> On Tue, May 26, 2009 at 3:15 AM, GeunSik Lim <leemgs1@gmail.com> wrote:
>> Hi,
>>
>> If you keep gcc 3.X.X to compile recent kernel source contiunally,
>> You will meet another problems again.
>>
>
> OK, so 3.x.x is officially not supposed to be used for compilation?
It not means that gcc 3.x.x don't support normal compilation of recent
kernel source officially. Below some cases is about gcc 3.x.x.
http://kerneltrap.org/mailarchive/linux-kernel/2008/1/8/547730
https://launchpad.net/ubuntu/hardy/+source/linux/2.6.24-23.48
https://bugzilla.redhat.com/show_bug.cgi?id=488991
>
>
and, I've mistyped a word. I  figured out typo thanks to Martin.
X)  http://linuxdistrowatch.com
O)  http://distrowatch.com/



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
