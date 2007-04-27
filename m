Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbXD0Oax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbXD0Oax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbXD0Oax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:30:53 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:42639 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755923AbXD0Oaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:30:52 -0400
X-Greylist: delayed 12002 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 10:30:51 EDT
Date: Fri, 27 Apr 2007 13:10:47 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Subject: More than 2Gb problem (dvb related) ?
Message-ID: <20070427111047.GB10284@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux 2.6.21
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a computer (mother Asus Commando) with 4x1Gb Ram.

If I start without the BIOS remap memory, my BIOS and linux just see 2Gb
of ram, and DVB apps works just great.

When I enable the remapping of the memory, my BIOS and linux just see
the whole 4Gb but then, I can tune to any transponder without problem,
but I am unable to get a TS...

I have tested it with vdr/kaffeine/mplayer.

szap/kaffeine/vdr get the lock just well.

I had already asked about this on just linux-dvb ml, but maybe I am the
first one to try DVB with a system with more than 2 Gb as I didn't
receive any further info as someone get it working or not with such
amount of ram.

Anyone got an idea on what could be done to solve this issue ?

PLEASE CC to me all message in lkml as I am not subscribed to this ml :)
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
