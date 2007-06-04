Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXFDRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXFDRlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXFDRlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:41:07 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42701 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXFDRlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:41:06 -0400
Date: Mon, 4 Jun 2007 19:35:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
In-Reply-To: <46644B97.2010506@zytor.com>
Message-ID: <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr>
References: <20070603142450.GA4230@localhost.localdomain>
 <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net>
 <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 4 2007 10:27, H. Peter Anvin wrote:
>Jeff Garzik wrote:
>> 
>> Seconded.  All my code contains the goto label in the first column.
>> 
>> IMO any other goto label indentation is silly, because it obscures the
>> goto label within the code block.
>
>I would have to disagree with this.  IMNSHO, a goto label is like a case
>label, and they should be treated the same way.

But gotos are special. ("Evil" minus the "it's good for unrolling in case of an
error" case).


	Jan
-- 
