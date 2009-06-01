Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZFAUIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZFAUIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZFAUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:07:59 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:42065 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZFAUH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pVIPwJgO7iuMWn+F0mw7OXseS662svoRfBgMrl9iHLutzZW/AIeaq93n09HIOVat/V
         9dmytFakvzZExKz7+N2hdy2yCA20AXYiDX70jGtWtJiK4AbUfuMmp1XDDg+KaUEu8fMb
         SINf3baJ4GlpH3s8Jjss8PrlTcyrAoM4Oc+yE=
MIME-Version: 1.0
In-Reply-To: <4A23F6B5.6010000@oracle.com>
References: <20090601200510.7b5334ab.sfr@canb.auug.org.au>
	 <4A23F6B5.6010000@oracle.com>
Date: Mon, 1 Jun 2009 22:07:58 +0200
Message-ID: <71cd59b00906011307s54e8df13h475d4689e7025d4e@mail.gmail.com>
Subject: Re: [PATCH] eeepc: fix kconfig problem
From: Corentin Chary <corentin.chary@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/1 Randy Dunlap <randy.dunlap@oracle.com>:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20090529:
>
>
> Resend.  linux-next still needs this patch.
>
> Len, what mailing list(s) should drivers/platform/x86/ patches
> be sent to?
>

Hi,
I believe the right list is linux-acpi.
Sorry, I forgot to join your patch to the last series I sent to Len.
Len, could you add this patch  ?
Thanks

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
