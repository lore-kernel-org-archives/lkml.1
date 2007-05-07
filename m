Return-Path: <linux-kernel-owner+w=401wt.eu-S966324AbXEGTdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966324AbXEGTdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966300AbXEGTdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:33:33 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:1308 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966256AbXEGTdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:33:32 -0400
From: James Cloos <cloos@jhcloos.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v10
In-Reply-To: <20070507184047.GA24430@elte.hu> (Ingo Molnar's message of "Mon\,
	7 May 2007 20\:40\:47 +0200")
References: <20070507163342.GA3502@elte.hu>
	<m3abwgqy5m.fsf@lugabout.jhcloos.org> <20070507184047.GA24430@elte.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:070507:linux-kernel@vger.kernel.org::iE0WFDWhHb4TVift:0000000000000000000000000000000003hcv
X-Hashcash: 1:23:070507:mingo@elte.hu::jNGWQdRbfIg3nMuk:0000q7rg
Date: Mon, 07 May 2007 15:32:19 -0400
Message-ID: <m3y7k0pgyt.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ingo" == Ingo Molnar <mingo@elte.hu> writes:

>> If instead of pulling master into the cfs branch, I rather switch to 
>> the master branch and pull the cfs branch into that, it works.

Ingo> ah! Could you please do a git-diff between the broken and the working 
Ingo> tree, to see what got mismerged?

Yes, I can work on that tonight.  There will be some noise, but at least
both have master == dc87c3985e9b442c60994308a96f887579addc39.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6


