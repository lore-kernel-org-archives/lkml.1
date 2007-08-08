Return-Path: <linux-kernel-owner+w=401wt.eu-S937978AbXHHR0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937978AbXHHR0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936699AbXHHRWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:22:32 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:58906 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937463AbXHHRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:22:26 -0400
Date: Wed, 8 Aug 2007 10:22:23 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Seokmann Ju <seokmann.ju@qlogic.com>, yanmin_zhang@linux.intel.com
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Message-ID: <20070808172223.GA897@plap.qlogic.org>
References: <46B9F664.9060600@googlemail.com> <46B9F983.9020700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B9F983.9020700@googlemail.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Aug 2007 17:21:25.0075 (UTC) FILETIME=[8C290A30:01C7D9E0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007, Michal Piotrowski wrote:

> Here is a list of some known regressions in 2.6.23-rc2.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
...
> SCSI
> 
> Subject         : unable to handle kernel NULL pointer dereference in qla2x00_read_nvram_data
> References      : http://lkml.org/lkml/2007/8/6/506
> Last known good : ?
> Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

Already addressed in Linus' latest GIT tree:

http://article.gmane.org/gmane.linux.scsi/33472/
