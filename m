Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYGEPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYGEPob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYGEPoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:44:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:34148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGEPoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wE0Vzz+8UOBKvsiL6Ril4Pw+nnFHShjreRLAZt9B7VjBRbg6NEs+rI4X7xyxB+fMEn
         xv1sly/BbCrvZxTofkgS3kecsz+bV1sG4wLthCGGSbQA3o04jVIDrH65krfolyTNf7WG
         u4wXrmMTmofLiNepmCYIefHRYSnDUVrv/wyfY=
Message-ID: <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com>
Date: Sat, 5 Jul 2008 18:44:21 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Battery life difference
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080705082352.4b6be669@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
	 <20080705082352.4b6be669@infradead.org>
X-Google-Sender-Auth: fb225c1f0fd1349c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 5, 2008 at 6:23 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> Which wireless is this? Same for graphics

intel iwl4965 and intel mobile bm965/GL960 (graphics)

> these don't give you all that much nowadays

hmm... interesting :-)
where should i look for more info ? Any pointers would be nice

> There's a few things you can do to help stuff along; make sure you're
> using AHCI.

not loaded. Thanks

> Also take a look at
> http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024 because
> these patches save like 0.75W in our lab.

cool, is it merged upstream ?
I'll build current git kernel and reply again with new linux results.
It could be that ubuntu 2.6.24 is broken somehow...

> To be honest, I'm surprised at your results; in our testing (with a
> different distro though) we don't see such a difference and Linux is
> doing rather well.

can you get powertop results in a 2.6.24 distro kernel and current git
kernel ?

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
