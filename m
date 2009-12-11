Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbZLKArG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbZLKArG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762107AbZLKArD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:47:03 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59924 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762079AbZLKAq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=no4v1SPjDHHlkMav+9o4yt5Q3FW4b/dzFPXKgpKzeEIAN2p+F5u081u1U2a6T/tPjc
         fUWbtxS+cUdMGRuTgb6txZGrdQYsstM2DFVoVsUm2L6Ojp0565B6Y6mta8r2hwV7oWS3
         7PDBik6ELhOsYKvjR8e0sbO0B45AK5aAhvBnY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912101623010.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	 <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	 <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
	 <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
	 <4B219046.3080908@pathscale.com>
	 <alpine.LFD.2.00.0912101623010.3560@localhost.localdomain>
Date: Fri, 11 Dec 2009 10:47:04 +1000
Message-ID: <21d7e9970912101647h5ae8514ak6ab78b9c26f3a642@mail.gmail.com>
Subject: Re: [git pull] drm
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?B?IkMuIEJlcmdzdHL2bSI=?= <cbergstrom@pathscale.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/11 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Thu, 10 Dec 2009, "C. Bergström" wrote:
>>
>> Thanks for the rather lengthly explanation, but in case you missed what people
>> are trying to say here..
>>
>> With all due respect Linus..
>>
>> "patches welcome"
>
> The problem is that I have never even heard a Red Hat or Fedora person
> actually acknoledge that yes, they should be trying to upstream it.

<Red Hat hat on>
<Fedora hat on>
We are trying to upstream nouveau.
<Fedora hat off>
<Red Hat hat off>

<DRM maintainer hat on>
The core DRM changes to support nouveau were but ugly, and shared
with radeon and vmware, we need to wait for VMware to re-write them.
VMware have rewritten them and they are upstream since radeon KMS
got merged into staging.
<DRM maintainer hat off>

<nouveau reviewer hat on>
The ctxprogs are legally dubious, we need to wait for Red Hat lawyers
to give us some direction, we can involve other lawyers but more
lawyers doesn't always help these things go faster.
<nouveau reviewer hat off>

<Dave hat on>
nvidia guys are laughing at us.
<Dave hat off>

Dave.
