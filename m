Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYLDVgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYLDVgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYLDVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:36:12 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:38522 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbYLDVgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:36:12 -0500
Date: Thu, 4 Dec 2008 22:35:59 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: linux-kernel@vger.kernel.org
Message-ID: <20081204213559.GA12403@excalibur.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Anyone working on an Intel Turbo Memory driver?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Today I found out that I have sitting a 2GB Intel Turbo Memory miniPCIe card in
my new notebook. lspci shows me the following for it:

04:00.0 Memory controller [0580]: Intel Corporation Turbo Memory Controller
[8086:444e] (rev 11)
        Subsystem: Intel Corporation Device [8086:444b]
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at f2600000 (32-bit, non-prefetchable) [size=1K]
        I/O ports at 2000 [size=256]
        [virtual] Expansion ROM at 80000000 [disabled] [size=64K]
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
        Capabilities: [68] Express Legacy Endpoint, MSI 01

So far I could not found any informations about linux support for it. All
sources claim that it is only supported in Windows vista.

Any informations form the Intel Open Source Labs for this? :)

http://www.intel.com/support/chipsets/itm/

regards
Stefan Schmidt
