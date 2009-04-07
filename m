Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZDGGA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZDGGA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZDGGAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:00:20 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:37829 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZDGGAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mofFsJYcgvUW+vz+loX/L7pLNO3IAgPk6fj9ZH0J/kmfM0UQDQKbyDZhsmG6v8AEk8
         3WYa1ixenllBZVDb+tz50zB6543HGCmNI9hx2Z9efXjq7AB2992ltZUfRRwQ2ecmC2G7
         k0U1evH8MflWi5gSU+nZybXtp784L9NFT942E=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 23:00:17 -0700
Message-ID: <dd18b0c30904062300o27b4bcd4n4fd28f31fb5cec3d@mail.gmail.com>
Subject: no sound with imac kernel=2.6.29
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a patch that I can test out for the latest imac.
At the moment I have no sound in either external/internal
speakers.

I've applied the imac91.patch submitted a few days ago(everything compiled
fine)but didn't realize it for a different card(or so I think)
below is lspci  -vvv
I can attach dmesg and supply info if need be.

00:08.0 Audio device: nVidia Corporation MCP79 High Definition Audio (rev b1)
        Subsystem: nVidia Corporation Device cb79
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0 (500ns min, 1250ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at d3480000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel



-- 
Justin P. Mattock
