Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYEMBJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYEMBJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbYEMBJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:09:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:45088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927AbYEMBI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:08:59 -0400
From: Neil Brown <neilb@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 May 2008 11:08:51 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18472.59939.115258.334458@notabene.brown>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
In-Reply-To: message from Dan Williams on Monday May 12
References: <200805031151.44287.prakash@punnoor.de>
	<18462.46639.578272.994939@notabene.brown>
	<20080505190159.GA329@kernel.dk>
	<200805082039.01316.rjw@sisk.pl>
	<1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
	<1210288690.9697.14.camel@dwillia2-linux.ch.intel.com>
	<18467.46015.146700.695469@notabene.brown>
	<18467.58198.777484.773976@notabene.brown>
	<1210614402.2640.10.camel@dwillia2-linux.ch.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 12, dan.j.williams@intel.com wrote:
> 
> Yes, this is simpler than what I had... spotted some fixups.
> 

Ahh, you noticed that I hadn't actually compiled it. :-)
Thanks.

I've set it off to Linus.

NeilBrown
