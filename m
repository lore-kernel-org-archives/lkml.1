Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYENK7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYENK7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 06:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYENK7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 06:59:14 -0400
Received: from mta1.siol.net ([193.189.160.88]:43279 "EHLO mta1.siol.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbYENK7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 06:59:14 -0400
Message-ID: <482AC5DC.1050701@siol.net>
Date: Wed, 14 May 2008 12:58:36 +0200
From: Grega Fajdiga <gregor.fajdiga@siol.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DVD-R drive error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this message when I'm trying to mount a DVD:

[  101.782461] attempt to access beyond end of device
[  101.782465] sr0: rw=0, want=68, limit=4
[  101.784408] attempt to access beyond end of device
[  101.784411] sr0: rw=0, want=1252, limit=4
[  101.784414] attempt to access beyond end of device
[  101.784416] sr0: rw=0, want=1028, limit=4
[  101.784417] UDF-fs: No partition found (1)
[  101.787177] attempt to access beyond end of device
[  101.787180] sr0: rw=0, want=68, limit=4
[  101.787183] isofs_fill_super: bread failed, dev=sr0, iso_blknum=16, 
block=16

Does it mean that the drive is dieing? My DVD player can read the drive 
just fine.

Please CC me as I'm not subscribed.

Thanks,
Grega Fajdiga
