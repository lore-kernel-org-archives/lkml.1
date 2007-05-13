Return-Path: <linux-kernel-owner+w=401wt.eu-S934871AbXEMQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871AbXEMQqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXEMQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:46:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:56191 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbXEMQqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:46:04 -0400
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: default y idiocy
References: <20070512182343.GO4629@kernel.dk>
	<46461C77.5040404@simon.arlott.org.uk>
	<1179003373.3723.34.camel@mulgrave.il.steeleye.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 13 May 2007 18:46:03 +0200
In-Reply-To: <1179003373.3723.34.camel@mulgrave.il.steeleye.com> (James Bottomley's message of "Sat, 12 May 2007 15:56:12 -0500")
Message-ID: <m3tzug7juc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> writes:

> drivers/ata/Kconfig has a select SCSI at the top, so if you selected
> modular ATA, you'll be forced to have modular SCSI.

Or built-in.
-- 
Krzysztof Halasa
