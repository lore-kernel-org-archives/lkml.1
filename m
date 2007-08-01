Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXHAOBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXHAOBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbXHAOBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:01:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54008 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbXHAOBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:01:36 -0400
Message-ID: <46B0923B.4040707@garzik.org>
Date: Wed, 01 Aug 2007 10:01:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, James.Bottomley@steeleye.com,
       edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [patch 1/4] Store interrupt value
References: <20070705194909.337398431@intel.com> <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
In-Reply-To: <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Use a stored value for which interrupts to enable.  Changing this allows
> us to selectively turn off certain interrupts later and have them 
> stay off.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

ACK.  Regenerate against current kernel and I'll apply immediately 
(tried to do so just now)


