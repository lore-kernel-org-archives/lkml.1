Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXFDSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXFDSDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXFDSDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:03:45 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbXFDSDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:03:45 -0400
Message-ID: <46645386.9060008@zytor.com>
Date: Mon, 04 Jun 2007 11:01:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr>            <46644F57.80005@zytor.com> <10880.1180979670@turing-police.cc.vt.edu>
In-Reply-To: <10880.1180979670@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
>>
>> You still want them to be associated with the level the bailout happens at.
> 
> No, you want them associated with the level you bail out *TO*.  Otherwise you
> get this:
> 

Right, I misspoke.

	-hpa
