Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZBBU5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZBBU5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZBBU5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:57:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:56688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZBBU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:57:41 -0500
Message-ID: <49875DD9.8070209@suse.com>
Date: Mon, 02 Feb 2009 15:55:53 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david.altobelli@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] increment hpilo version
References: <20090123142529.GA5298@ldl.fc.hp.com>	<49874FE2.6030800@suse.com> <20090202121412.f9687c29.akpm@linux-foundation.org>
In-Reply-To: <20090202121412.f9687c29.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> On Mon, 02 Feb 2009 14:56:18 -0500
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> David Altobelli wrote:
>>> Bump hpilo module version to indicate that the open/close bug is fixed.
>> Hi David -
>>
>> Was the open/close bug fixed in a differently than with your patch in
>> "[PATCH] hpilo open/close fix" ? If not, the fix didn't make it into
>> mainline, but this version bump did.
> 
> I'll be sending hpilo-open-close-fix.patch in the next batch, this week
> some time.

Ok, thanks. I was just making sure it didn't get dropped by accident.

- -Jeff

> If you grab http://userweb.kernel.org/~akpm/mmotm/series you can see
> what I have queued for 2.6.29.  Look for
> 
> #
> # 2.6.29 queue:
> #
> 
> and
> 
> #
> # more 2.6.29 queue:
> #
> 
> The first is soon-to-go stuff, the second is
> to-go-after-a-bit-more-baking stuff.
> 
> 
> Also,
> 
> #
> # others:
> #
> 
> is stuff which I think might be needed in 2.6.29 but which go via
> subsystem maintainers trees.
> 
> The latter is not (yet) as lengthy as usual, but there's still quite a
> bit of material:
> 
> 
> acpi-kconfig-fix-acpi_container-module-name.patch
> acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch
> arm-at91-fix-nr_aic_irqs-undeclared.patch
> drivers-ata-sata_silc-needs-dmih.patch
> pata_amd-program-fifo.patch
> pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop.patch
> mfd-initialise-wm8350-interrupts-earlier.patch
> mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch
> mfd-pcf50633-terminate-i2c_device_id-list.patch
> mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice.patch
> net-dont-use-in_atomic-in-gfp_any.patch
> documentation-connector-cn_testc-dont-use-gfp_any.patch
> nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
> powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
> atmel_serial-might-lose-modem-status-change.patch
> pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
> xtensa-fix-compilation-somewhat.patch
> 


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkmHXdkACgkQLPWxlyuTD7IvsACeNszw/i/0eXWLzNn0+3JidfU/
kLsAn0fz+nNC+lFUxhq5dsT5s37Tz0Al
=yzFe
-----END PGP SIGNATURE-----
