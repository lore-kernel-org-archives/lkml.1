Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbZLKK2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbZLKK2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbZLKK2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:28:39 -0500
Received: from mail-yw0-f173.google.com ([209.85.211.173]:57859 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZLKK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=U/al9cRAyntnKj37CtSTwVGLuwJbdUnA6Civt4+2CDbTeQggOC8KzfYA8zXEmQ61Mb
         g5g+36tlbu1kIg9l+QvFC7JpvO0PqizbRdiAsNx51tGvzsbVNmoStj27rlHuYaVHSWAN
         7dSxa4+fNynFp5uq7oruE0jfEMnR/zc5Elg+Y=
Message-ID: <4B221EDA.5020902@garzik.org>
Date: Fri, 11 Dec 2009 05:28:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>	<1260459601.18520.26.camel@skunk>	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>	<6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>	<alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>	<20091210235835.20e2269d@lxorguk.ukuu.org.uk>	<alpine.LFD.2.00.0912101601100.3560@localhost.localdomain> <20091211091843.0a543136@lxorguk.ukuu.org.uk>
In-Reply-To: <20091211091843.0a543136@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 04:18 AM, Alan Cox wrote:
> F11 certainly shipped some bits of it for 2D support. I am not sure if
> F10 shipped a purely userspace set up. Neither had it enabled as the
> default driver - they used "nv" or "vesa" depending upon the card.

F11 uses nouveau here.  It is actually a pain to get 'nv' going as an 
alternate -- bugs have been filed.  Makes kernel dev more difficult for 
me.  I was actually told, by Fedora people, that I should be hacking on 
the Fedora (rpm-based) kernel, rather than a 100% upstream kernel like I 
have been hacking/booting for the past decade, as a result of this setup 
(needing nouveau kernel support, thus needing Fedora rather than 
upstream kernel).

	Jeff


