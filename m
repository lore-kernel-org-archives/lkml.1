Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXJVLCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXJVLCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXJVLCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:02:16 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:34650 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbXJVLCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:02:15 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: sata sil3114 vs. certain seagate drives results in filesystem corruptions
Date: Mon, 22 Oct 2007 13:02:11 +0200
User-Agent: KMail/1.9.6
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
References: <1192863324.5720.162.camel@localhost> <200710221148.08809.bs@q-leap.de> <1193049392.10246.29.camel@localhost>
In-Reply-To: <1193049392.10246.29.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221302.12229.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 12:36:32 Soeren Sonnenburg wrote:
> > but as much as it fits onto the disk. On reading back this file, the
> > filesystem will report errors somewhere between 50GB and 230GB (disk size
> > is 250GB).
>
> Wow, I really see lots of corruptions (well every 1-2 GB a couple of
> bytes are corrupted). Are you getting similiarly many in the 50G - 230G
> region?

I never tested what is corrupted. Well, a diff over 250GB would take quite a 
lot of time...

-- 
Bernd Schubert
Q-Leap Networks GmbH
