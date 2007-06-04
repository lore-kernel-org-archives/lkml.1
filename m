Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbXFDRaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbXFDRaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbXFDRaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:30:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbXFDRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:30:20 -0400
Message-ID: <46644B97.2010506@zytor.com>
Date: Mon, 04 Jun 2007 10:27:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain>	<20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org>
In-Reply-To: <4662DFCF.3010606@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Seconded.  All my code contains the goto label in the first column.
> 
> IMO any other goto label indentation is silly, because it obscures the
> goto label within the code block.
> 

I would have to disagree with this.  IMNSHO, a goto label is like a case
label, and they should be treated the same way.

	-hpa
