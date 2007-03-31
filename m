Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXCaVyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXCaVyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXCaVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:54:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39521 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552AbXCaVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:54:13 -0400
Date: Sat, 31 Mar 2007 23:54:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.46
Message-ID: <20070331215412.GG14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.45:

Adrian Bunk (2):
      Linux 2.6.16.46-rc1
      Linux 2.6.16.46

Akinbou Mita (1):
      md: fix /proc/mdstat refcounting

Alan Stern (10):
      usb-storage: unusual_devs entry for Nikon DSC D70s
      USB: unusual_devs entry for Nokia N80
      USB: unusual_devs entry for Nokia N91
      USB: unusual_devs entry for Nokia E61
      USB: unusual_devs entry for Lacie DVD+-RW
      USB: unusual-devs entry for Nokia E60
      USB: unusual_devs entry for Nokia 6131
      USB: unusual_devs entry for Nokia 6234
      unusual_devs update for UCR-61S2B
      USB: unusual_devs update for Sony P990i phone

Amol Lad (1):
      sound/pci/au88x0/au88x0.c: ioremap balanced with iounmap

Andrew Nayenko (1):
      USB storage: Nokia 6288 unusual_devs entry

Andy Isaacson (1):
      fix read past end of array in md/linear.c

Clemens Ladisch (1):
      usb-audio: work around wrong frequency in CM6501 descriptors

David Kuehling (1):
      USB: unusual_devs entry for A-VOX WSX-300ER MP3 player

Davide Perini (1):
      usb-storage: unusual_devs entry for Motorola RAZR V3x

Dylan Taft (1):
      USB Storage: US_FL_IGNORE_RESIDUE needed for Aiptek MP3 Player

Eric Sesterhenn (1):
      [ALSA] fix NULL pointer dereference in sound/synth/emux/soundfont.c

Ernis (1):
      USB: unusual_devs entry for Samsung MP3 player

Florin Malita (1):
      [ALSA] Dereference after free in snd_hwdep_release()

Guennadi Liakhovetski (1):
      [PPP]: Don't leak an sk_buff on interface destruction.

Jaco Kroon (1):
      USB: add Digitech USB-Storage to unusual_devs.h

Jürgen Mell (1):
      USB floppy drive SAMSUNG SFD-321U/EP was detected 8 times

Lars Ellenberg (1):
      md: pass down BIO_RW_SYNC in raid{1,10}

Lars Jacob (1):
      USB: unusual_devs entry for Sony DSC-H5

Luiz Fernando N. Capitulino (1):
      USB: unusual_devs.h for Sony floppy

Manuel Osdoba (1):
      USB: unusual_devs.h entry for nokia 6233

Mario Rettig (1):
      USB: unusual_devs entry for Nokia 3250

Mikko Honkala (1):
      USB: Nokia E70 is an unusual device

Neil Brown (2):
      MD: Fix problem where hot-added drives are not resynced.
      md: Fix bug where spares don't always get rebuilt properly when they become live

Nick Piggin (1):
      mm: fix madvise infinine loop

Olivier Blondeau (1):
      USB: storage: atmel unusual dev update

Patrick McHardy (3):
      [NET_SCHED]: Fix endless loops caused by inaccurate qlen counters
      [NET_SCHED]: cls_basic: fix NULL pointer dereference
      [NET_SCHED]: Fix ingress locking

Pete Zaitcev (3):
      USB storage: fix ipod ejecting issue
      USB: unusual_devs.h for 0x046b:ff40
      USB: RAZR v3i unusual_devs

Phil Dibowitz (11):
      USB: storage: sandisk unusual_devices entry
      USB: storage: another unusual_devs.h entry
      USB: storage: unusual_devs.h entry 0420:0001
      USB: Storage: unusual devs update
      USB Storage: US_FL_MAX_SECTORS_64 flag
      USB: another unusual device
      USB Storage: unusual_devs.h for Sony Ericsson M600i
      USB: unusual_dev entry for Sony P990i
      USB: usb-storage: Unusual_dev update
      USB Storage: unusual_devs: add supertop drives
      USB: Fix UCR-61S2B unusual_dev entry

Rodolfo Quesada (1):
      USB: storage: new unusual_devs.h entry: Mitsumi 7in1 Card Reader

Russell King (1):
      [SERIAL] Fix oops when removing suspended serial port

Stefan Richter (1):
      ieee1394: dv1394: fix CardBus card ejection

Takashi Iwai (6):
      [ALSA] hda-codec - Don't return error at initialization of modem codec
      [ALSA] hda-intel - Don't try to probe invalid codecs
      [ALSA] Fix invalid assignment of PCI revision
      [ALSA] cmipci - Fix a typo in 'PC Speaker Playback Switch' control
      [ALSA] cs4281 - Fix the check of right channel
      [ALSA] ca0106 - Add missing sysfs device assignment

Tobias Lorenz (1):
      USB: Mitsumi USB FDD 061M: UNUSUAL_DEV multilun fix

YOSHIFUJI Hideaki (1):
      [IPV6] HASHTABLES: Use appropriate seed for caluculating ehash index.


 Makefile                           |    2 
 drivers/ieee1394/dv1394.c          |   17 -
 drivers/md/linear.c                |    2 
 drivers/md/md.c                    |    3 
 drivers/md/raid1.c                 |   13 -
 drivers/md/raid10.c                |   11 -
 drivers/net/ppp_generic.c          |    3 
 drivers/serial/serial_core.c       |    9 
 drivers/usb/storage/scsiglue.c     |   12 -
 drivers/usb/storage/unusual_devs.h |  285 +++++++++++++++++++++++++++--
 drivers/usb/storage/usb.h          |    4 
 include/linux/serial_core.h        |    1 
 include/linux/usb_usual.h          |    2 
 include/net/sch_generic.h          |    4 
 include/sound/ymfpci.h             |    2 
 mm/madvise.c                       |    5 
 net/core/dev.c                     |    4 
 net/ipv6/inet6_hashtables.c        |    2 
 net/sched/cls_basic.c              |   17 -
 net/sched/sch_api.c                |   39 +++
 net/sched/sch_atm.c                |    5 
 net/sched/sch_cbq.c                |   10 -
 net/sched/sch_dsmark.c             |    7 
 net/sched/sch_generic.c            |    7 
 net/sched/sch_hfsc.c               |   30 ++-
 net/sched/sch_htb.c                |   39 ++-
 net/sched/sch_netem.c              |    5 
 net/sched/sch_prio.c               |   14 +
 net/sched/sch_sfq.c                |    3 
 net/sched/sch_tbf.c                |   15 +
 sound/core/hwdep.c                 |    3 
 sound/pci/au88x0/au88x0.c          |    1 
 sound/pci/ca0106/ca0106.h          |    2 
 sound/pci/ca0106/ca0106_main.c     |    4 
 sound/pci/cmipci.c                 |    2 
 sound/pci/cs4281.c                 |    2 
 sound/pci/emu10k1/emu10k1x.c       |    4 
 sound/pci/hda/hda_intel.c          |   12 +
 sound/pci/hda/patch_si3054.c       |    3 
 sound/pci/ymfpci/ymfpci_main.c     |    2 
 sound/synth/emux/soundfont.c       |    2 
 sound/usb/usbaudio.c               |    8 
 42 files changed, 490 insertions(+), 127 deletions(-)

