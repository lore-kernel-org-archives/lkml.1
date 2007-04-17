Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbXDQNwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbXDQNwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbXDQNwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:52:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbXDQNwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:52:16 -0400
Message-ID: <4624CECD.2070805@zytor.com>
Date: Tue, 17 Apr 2007 06:42:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Alain.Knaff@poboxes.com
Subject: Re: floppy.ko
References: <200704170036.00605.gene.heskett@verizon.net>
In-Reply-To: <200704170036.00605.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> 
> I have the usual fd0, a 3.5" 1.44 drive, and fd1, a 5.25" 720k drive in this 
> machine, both are enabled in the bios with the correct types being set there.
> 

A 5.25" 720k drive?!  That's not a PC standard drive -- 5.25" came in 
180K, 360K and 1200K varieties, whereas 3.5" came in 720K, 1440K and 
2880K varieties (not including superfloppies.)

	-hpa

