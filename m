Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbZG2OPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbZG2OPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZG2OPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:15:13 -0400
Received: from fifo99.com ([67.223.236.141]:46243 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZG2OPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:15:13 -0400
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090729134229.529582732@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
	 <20090729134229.529582732@de.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 07:15:30 -0700
Message-Id: <1248876930.28841.161.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-inline.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Remove clocksource_read, clocksource_enable and clocksource_disable
> inline functions. No functional change.
> 

Your still not really explaining this one, is this suppose to be
cleaner? Or is this related to some other part of your clean up?

Daniel

