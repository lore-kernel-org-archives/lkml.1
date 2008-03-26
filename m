Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYCZWoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYCZWoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYCZWoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:44:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:49292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbYCZWoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:44:00 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [patch 00/37] PNP resource_table cleanups
Date: Wed, 26 Mar 2008 18:42:10 -0400
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080326171058.099442579@ldl.fc.hp.com>
In-Reply-To: <20080326171058.099442579@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261842.11023.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386:

#1 errs.ACPI.ACPI_DEBUG.ACPI_PROCFS.HIBERNATION.X86_LOCAL_APIC.X86_IO_APIC
Cleaning...Building...
ERROR: "pnp_get_resource" [sound/oss/sb.ko] undefined!
ERROR: "pnp_get_resource" [sound/oss/ad1848.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/wavefront/snd-wavefront.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-sscape.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-opl3sa2.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-es18xx.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-dt019x.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-cmi8330.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-azt2320.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/snd-als100.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/sb/snd-sbawe.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/sb/snd-sb16.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/sb/snd-es968.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/opti9xx/snd-opti93x.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/opti9xx/snd-opti92x-cs4231.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/opti9xx/snd-opti92x-ad1848.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/gus/snd-interwave.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/gus/snd-interwave-stb.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/cs423x/snd-cs4236.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/cs423x/snd-cs4232.ko] undefined!
ERROR: "pnp_get_resource" [sound/isa/ad1816a/snd-ad1816a.ko] undefined!
ERROR: "pnp_get_resource" [sound/drivers/mpu401/snd-mpu401.ko] undefined!
ERROR: "pnp_get_resource" [drivers/watchdog/sc1200wdt.ko] undefined!
ERROR: "pnp_get_resource" [drivers/telephony/ixj.ko] undefined!
ERROR: "pnp_get_resource" [drivers/scsi/sym53c416.ko] undefined!
ERROR: "pnp_get_resource" [drivers/scsi/g_NCR5380_mmio.ko] undefined!
ERROR: "pnp_get_resource" [drivers/scsi/g_NCR5380.ko] undefined!
ERROR: "pnp_get_resource" [drivers/scsi/aha1542.ko] undefined!
ERROR: "pnp_get_resource" [drivers/scsi/aha152x.ko] undefined!
ERROR: "pnp_get_resource" [drivers/pcmcia/i82365.ko] undefined!
ERROR: "pnp_get_resource" [drivers/parport/parport_pc.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/smc-ultra.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/sb1000.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/ne.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/irda/smsc-ircc2.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/irda/nsc-ircc.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/3c515.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/3c509.ko] undefined!
ERROR: "pnp_get_resource" [drivers/mmc/host/wbsd.ko] undefined!
ERROR: "pnp_get_resource" [drivers/media/radio/radio-sf16fmi.ko] undefined!
ERROR: "pnp_get_resource" [drivers/media/radio/radio-cadet.ko] undefined!
ERROR: "pnp_get_resource" [drivers/isdn/hisax/hisax_fcpcipnp.ko] undefined!
ERROR: "pnp_get_resource" [drivers/isdn/hisax/hisax.ko] undefined!
ERROR: "pnp_get_resource" [drivers/input/gameport/ns558.ko] undefined!
ERROR: "pnp_get_resource" [drivers/ide/ide-pnp.ko] undefined!
ERROR: "pnp_get_resource" [drivers/char/tpm/tpm_tis.ko] undefined!
ERROR: "pnp_get_resource" [drivers/char/tpm/tpm_infineon.ko] undefined!
Build FAILED

x86_64:

#33 errs.allmodconfig
Cleaning...Building...
ERROR: "pnp_get_resource" [sound/oss/sb.ko] undefined!
ERROR: "pnp_get_resource" [sound/drivers/mpu401/snd-mpu401.ko] undefined!
ERROR: "pnp_get_resource" [drivers/watchdog/sc1200wdt.ko] undefined!
ERROR: "pnp_get_resource" [drivers/serial/8250_pnp.ko] undefined!
ERROR: "pnp_get_resource" [drivers/rtc/rtc-cmos.ko] undefined!
ERROR: "pnp_get_resource" [drivers/parport/parport_pc.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/sb1000.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/irda/smsc-ircc2.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/irda/nsc-ircc.ko] undefined!
ERROR: "pnp_get_resource" [drivers/mmc/host/wbsd.ko] undefined!
ERROR: "pnp_get_resource" [drivers/input/serio/i8042.ko] undefined!
ERROR: "pnp_get_resource" [drivers/input/gameport/ns558.ko] undefined!
ERROR: "pnp_get_resource" [drivers/ide/ide-pnp.ko] undefined!
ERROR: "pnp_get_resource" [drivers/char/tpm/tpm_tis.ko] undefined!
ERROR: "pnp_get_resource" [drivers/char/tpm/tpm_infineon.ko] undefined!
Build FAILED


ia64:

#9 errs.allmodconfig
Cleaning...Building...
ERROR: "pnp_get_resource" [sound/drivers/mpu401/snd-mpu401.ko] undefined!
ERROR: "pnp_get_resource" [drivers/serial/8250_pnp.ko] undefined!
ERROR: "pnp_get_resource" [drivers/parport/parport_pc.ko] undefined!
ERROR: "pnp_get_resource" [drivers/net/sb1000.ko] undefined!
ERROR: "pnp_get_resource" [drivers/input/serio/i8042.ko] undefined!
ERROR: "pnp_get_resource" [drivers/input/gameport/ns558.ko] undefined!
ERROR: "pnp_get_resource" [drivers/ide/ide-pnp.ko] undefined!
ERROR: "pnp_get_resource" [drivers/char/tpm/tpm_tis.ko] undefined!
ERROR: "pnp_get_resource" [drivers/char/tpm/tpm_infineon.ko] undefined!
Build FAILED
