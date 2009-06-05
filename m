Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZFEIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZFEIRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZFEIGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:36 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:65333 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZFEIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=I6XpPg+BgCzEt6trBp662G5st5RoCm9jTr97CANFWlCn50hx2lK7vh5Bmt2eaXKIjL
         oFxLg9+8oHK4vLFzVrOQZxVsks4J8+doDmaeX1noyt5c/GZCixMCLjUIyqeONfkQUKei
         Mvq8YCZ/gThfuPBL/D9g39ONprrNfXoeiTMGk=
Date: Fri, 5 Jun 2009 16:04:06 +0800
From: hu.taoo@gmail.com
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Luck Tony <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header
	file
Message-ID: <20090605080406.GA1285@gentoo-ht>
Mail-Followup-To: hu.taoo@gmail.com,
	Amerigo Wang <xiyou.wangcong@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
	Richard Henderson <rth@twiddle.net>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
	Hirokazu Takata <takata@linux-m32r.org>,
	Luck Tony <tony.luck@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Ralf Baechle <ralf@linux-mips.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@mcmartin.ca>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Paul Mundt <lethal@linux-sh.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
References: <4A280BB0.4030805@oracle.com> <20090605004329.GA7653@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090605004329.GA7653@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:43:29AM +0800, Amerigo Wang wrote:
> 
> UML only uses KM_TYPE_NR and KM_UML_USERCOPY, so
> this patch should be fine for UML.
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

You probably need a Reviewed-by:...

FYC, Acked-by and Reviewed-by are well documented
in Documentation/SubmittingPatches.
