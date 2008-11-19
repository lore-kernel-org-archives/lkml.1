Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYKSMZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYKSMZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYKSMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:25:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:39040 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYKSMZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=agv1DMt/Ob+F0Iiwa3uGhgHGi7KigNyeXUmtiOnXPDZ9jFfSoSNpi3+x3zFJ+SZljP
         X+KJ5XloP/nwV2L1sPQesFEiKaUUrwwlDblZNRNOqqVyNrF2x6DYZXe1tceKt44Q4wP5
         lo1Cm6LslNfCAI0pRaU6oPHFaXtGysdjKE7Mo=
Message-ID: <ca35ce500811190425i221a1fcapaaaf1cd9cae0a011@mail.gmail.com>
Date: Wed, 19 Nov 2008 13:25:38 +0100
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>, linux-kernel@vger.kernel.org
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
In-Reply-To: <200707250103.54477.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <ca35ce500707110955t44d9b998r769c02df3e29e00a@mail.gmail.com>
	 <ca35ce500707190324ncc7fbc0r4f05e00c74186dcc@mail.gmail.com>
	 <200707250103.54477.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 12:03 AM, Duncan Sands
<duncan.sands@math.u-psud.fr> wrote:

>> Do you have any news regarding my case of slow transfers via
>> Speedtouch USB modem on linux ?
>
> I found my old speedtouch modem and tested here.  I got 2.1 Mbaud
> bulk downspeed, and 3 Mbaud isoc downspeed.  This last is half the
> speed my line supports, so something is wrong [*].  Unfortunately
> I'm not very motivated to try to find out what, because I don't
> use this modem myself anymore.  It looks like someone needs to do
> some more reverse engineering work on the windows driver.

Duncan, as you remember we discussed 1 year ago speed issues with
Speedtouch driver. Please let me know if the driver has been fixed to
support higher speeds? Or is it still limited to 3Mbaud top ?

Regards,
MK
