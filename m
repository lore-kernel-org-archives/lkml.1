Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYBDTUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYBDTUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYBDTTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:19:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:47960 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYBDTTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s953srttDgetWLO9qkBOh82Ox3PNooIf8vlxllqKi580jt1SsJ5+37MqKoRg+hx/+rpbrL/m85Tb+KiJ3E9TdvdYkEMGyUAF+dmzf+ZXqkKjRtnru/olbfv0FWbzdSNTerfyrMCJDH6pBU7L8PkzLnukElfSwZjHKdo60hv+uss=
Message-ID: <6101e8c40802041119y3dd1706cvb70944babd33abca@mail.gmail.com>
Date: Mon, 4 Feb 2008 20:19:49 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [Kconfig {SM,E}] 2.6.24-git13 9135f1901ee6449dfe338adf6e40e9c2025b8150
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080204191305.GC16050@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802040556y7c58a729m13c4f3e81aff001@mail.gmail.com>
	 <20080204191305.GC16050@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/08, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Oliver.
>
> On Mon, Feb 04, 2008 at 02:56:07PM +0100, Oliver Pinter (Pintér Olivér)
> wrote:
> > git top: 9135f1901ee6449dfe338adf6e40e9c2025b8150
> >
> > -------8<-------
> > drivers/spi/Kconfig:156:warning: 'select' used by config symbol
> > 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
> >
> > WARNING: vmlinux.o(.text+0xe01e): Section mismatch in reference from
> > the function acpi_unmap_lsapic() to the variable
> > .cpuinit.data:num_processors
> ...
> Yes - we all see them. They will soon be silenced and only
> a summarycounter is printed.
> For now you can safely ignore them.
>
> >
> > make[4]: Warning: File `/dev/null' has modification time 2,1e+03 s in the
> future
> > make[5]: Warning: File `/dev/null' has modification time 2,1e+03 s in the
> future
> >   CHECK   include/asm-generic/errno-base.h
>
> These looks strange. I have not seen this message before.
> Did you adjust your clock backwards recently?
>

no, never, and i neither have running ntp...
> 	Sam
>
>


-- 
Thanks,
Oliver
