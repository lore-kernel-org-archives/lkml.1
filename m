Return-Path: <linux-kernel-owner+w=401wt.eu-S1161159AbXDQT4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159AbXDQT4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161194AbXDQT4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:56:46 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:37126 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1161159AbXDQT4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:56:44 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Message-ID: <46252675.9010201@wizy.org>
Date: Tue, 17 Apr 2007 20:56:37 +0100
From: Ricardo Correia <linux-kernel@wizy.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: Theodore Tso <tytso@mit.edu>, Daniel Hazelton <dhazelton@enter.net>,
       =?ISO-8859-1?Q?Tomasz_K=3Foczko?= <kloczek@rudy.mif.pg.gda.pl>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>	<20070417131045.GB18373@thunk.org>	<Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>	<200704171222.19892.dhazelton@enter.net>	<20070417175055.GA24963@thunk.org> <87odlmrei0.fsf@mid.deneb.enyo.de>
In-Reply-To: <87odlmrei0.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Weimer wrote:
> <http://opensolaris.org/os/community/zfs/faq/#zfspanic>
> 
> I keep hoping that this FAQ entry is outdated, but the date on that
> page is rather current. 8-/

That FAQ entry is outdated, ZFS can recover from metadata corruption on
non-replicated pools for a long time already.

Background scrubbing and the ability to see a list of corrupted files
has also been available for a long time (even longer than the above).

