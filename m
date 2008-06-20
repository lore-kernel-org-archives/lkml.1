Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYFTCgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYFTCgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 22:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYFTCg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 22:36:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:39728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYFTCg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 22:36:28 -0400
Date: Thu, 19 Jun 2008 19:36:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [patch 1/2] x86: apic: Export symbols for extended interrupt
 LVT functions
Message-ID: <20080619193600.240c721a@infradead.org>
In-Reply-To: <20080619170056.GI10019@erda.amd.com>
References: <20080213151811.804698000@amd.com>
	<20080213151841.520543000@amd.com>
	<20080213143256.54e9a3c7@laptopd505.fenrus.org>
	<20080214094036.GA16892@erda.amd.com>
	<20080214084749.2a936f85@laptopd505.fenrus.org>
	<20080619170056.GI10019@erda.amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 19:00:56 +0200
Robert Richter <robert.richter@amd.com> wrote:

> Arjan,
> 
> do you see a way of how to get these EXPORT_SYMBOLs mainline? 

it's easy... submit the code that uses them.....


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

