Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXKZXOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXKZXOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXKZXOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:14:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:28209 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXKZXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Sc7AT+7/K072b0g/ofCKLJBkGemhZkj82lpxOPfB15qJZF1X4cZ8g1+fFNYubcGSo6GgqvNO3O1+Jl0QWfuxGzo5UKzDD3mWM9vjSZ+PPDn5iY1ZSwe8VgXPRk/YdebGaYL9iKEcopKlr1z/xhJX9XbK4l6Cyfr2wymwgUQUnUE=
Message-ID: <474B5349.2070500@gmail.com>
Date: Tue, 27 Nov 2007 00:14:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, riel@redhat.com, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, clameter@sgi.com
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<4743CC0B.9000508@linux.vnet.ibm.com>	<20071120221839.faab108e.akpm@linux-foundation.org>	<20071126143943.0a01665b@cuia.boston.redhat.com>	<20071126123319.7483e57f.akpm@linux-foundation.org>	<20071126204540.GA19874@elte.hu>	<474B43E1.9080407@gmail.com> <20071126141713.3dcd492b.akpm@linux-foundation.org>
In-Reply-To: <20071126141713.3dcd492b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2007 11:17 PM, Andrew Morton wrote:
>> Maybe if you can emit a broken-out with the fresh pull to test?
> 
> http://userweb.kernel.org/~akpm/mmotm/ is current.  But it probably won't
> compile. 

Yes it did :). And it worked. Both in qemu and on my desktop...

qemu output at:
http://www.fi.muni.cz/~xslaby/sklad/qemu-output.txt

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
