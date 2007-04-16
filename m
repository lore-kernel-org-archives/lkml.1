Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXDPODQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXDPODQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXDPODQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:03:16 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:59979 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXDPODP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:03:15 -0400
Message-ID: <46238204.9060907@s5r6.in-berlin.de>
Date: Mon, 16 Apr 2007 16:02:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Mike Snitzer <snitzer@gmail.com>,
       Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqqwdfzcftfxs2@localhost.localdomain>  <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K³oczko wrote:
> Current FUSE implemntation can't be 
> comparable in aspects of speed and probably never will be on using threads

Did you measure this on a few hardwares and workloads?

> (very simmilar case to ALSA and mixing in user space ..

Audio is about guaranteed latency, not "speed".
-- 
Stefan Richter
-=====-=-=== -=-- -==-=
http://arcgraph.de/sr/
