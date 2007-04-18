Return-Path: <linux-kernel-owner+w=401wt.eu-S2992530AbXDROGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992530AbXDROGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992533AbXDROGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:06:22 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:46062 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992530AbXDROGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AYPF2D4EIp0Ck3CDwrmhksucIbHHDh45Op3fxNuHKPdluD6yMJl0TfNxEjCC5GfV/FBrs76ZpFKglJjxdEQxdrBPlKbv1neLqEPzxMcqxnCfXl6y53wGD05wn2h9HV3ut9Na9YBWeeY19gggxMuWZtJccbMsg1YoFOqQ1Wq1DxI=
Message-ID: <f4050c9e0704180706m513dd780v79f30f0029fe74de@mail.gmail.com>
Date: Wed, 18 Apr 2007 08:06:18 -0600
From: "Andrew Shewmaker" <agshew@gmail.com>
To: "John Sigler" <linux.kernel@free.fr>
Subject: Re: Disabling x86 System Management Mode
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <462603E0.3050208@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de>
	 <462603E0.3050208@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/07, John Sigler <linux.kernel@free.fr> wrote:
> Andi Kleen wrote:
>
> > There are usually chipset specific bits that can be set to disable
> > SMMs. See the datasheet if you can get them. Unfortunately most
> > chipset vendors don't give out data sheets easily.
>
> I managed to find the south bridge data sheet.
>
> http://linux.kernel.free.fr/VT82C686B.pdf
>
> (I'm still looking for the north bridge data sheet.)
>
> Could someone point me in the right direction?

The LinuxBIOS folks had a thread on SMM recently.  You don't have to
worry about SMM if you can use their stuff.

http://www.linuxbios.org/pipermail/linuxbios/2006-December/017861.html

same thread, but continued

http://www.linuxbios.org/pipermail/linuxbios/2007-January/017905.html

-- 
Andrew Shewmaker
