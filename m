Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYFDNlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYFDNlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYFDNkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:40:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:17472 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYFDNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FZnP99Kq9MqHdgppKUZJycqsNFU45tj08ajUbZxJQnaVucumijTtntF/hQCtJlQUTE
         JjoIRkLiUvIBi22rVDUD6cT8BWD5wjJqvdmXos2D7nkFVMOfN66J4qgl//UWPrxJ+xkd
         PyDFPtX8UFIdfYnR1OUHZyrwOdrEFS0St17u8=
Message-ID: <e2e108260806040640k3ffb9712j443c2da37feb394c@mail.gmail.com>
Date: Wed, 4 Jun 2008 15:40:49 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: Lkm <lkm@lea-linux.com>
Subject: Re: PROBLEM: Hardware clock instable
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806041517.43347.lkm@lea-linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806041402.39515.lkm@lea-linux.com>
	 <e2e108260806040549p11117410x192d1020adb885c7@mail.gmail.com>
	 <200806041517.43347.lkm@lea-linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 3:17 PM, Lkm <lkm@lea-linux.com> wrote:
> Ntpd logs:
...
>  2 Jun 13:42:20 ntpd[2299]: time reset -109.498922 s
...

The reason I asked for the ntpd logs is that I'm still not sure
whether there is a hardware problem. How long was the ntpd process
running when the above line was logged ? And can you also post the
output of ntpq -pn ?

Bart.
