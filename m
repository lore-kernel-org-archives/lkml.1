Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZAZQAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZAZQAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZAZP77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:59:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:57510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZAZP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:59:59 -0500
Date: Mon, 26 Jan 2009 07:59:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: marching through all physical memory in software
Message-ID: <20090126075957.69b64a2e@infradead.org>
In-Reply-To: <497DD8E5.1040305@nortel.com>
References: <497DD8E5.1040305@nortel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 09:38:13 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> Someone is asking me about the feasability of "scrubbing" system
> memory by accessing each page and handling the ECC faults.
> 

Hi,

I would suggest that you look at the "edac" subsystem, which tries to
do exactly this....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
