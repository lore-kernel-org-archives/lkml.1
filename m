Return-Path: <linux-kernel-owner+w=401wt.eu-S1765660AbXGaQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765660AbXGaQQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXGaQP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:15:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44986 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbXGaQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:15:56 -0400
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
From: Arjan van de Ven <arjan@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
In-Reply-To: <46AF4B05.4010700@gmail.com>
References: <20070705194909.337398431@intel.com>
	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>
	 <1185891382.2750.8.camel@laptopd505.fenrus.org>
	 <46AF4B05.4010700@gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 31 Jul 2007 09:15:31 -0700
Message-Id: <1185898532.2766.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> They were hardware problems.  I don't think any amount of proper
> implementation can fix them.  I have one DVD RAM somewhere in my pile of
> hardware which locks up solidly if any link PS mode is used and had a

and the AHCI ALPM code decides to use power savings on this device? if
so, please give us the idents so that we can add it to the blacklist as
the first entry... (or can buy it to check it in detail first)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

