Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXJAT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXJAT6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXJAT6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:58:07 -0400
Received: from woody.df.uba.ar ([157.92.11.66]:45850 "EHLO woody.df.uba.ar"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbXJAT6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:58:05 -0400
X-Greylist: delayed 2428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 15:58:03 EDT
Message-ID: <47014740.5080002@df.uba.ar>
Date: Mon, 01 Oct 2007 16:15:12 -0300
From: Hernan Gustavo Solari <solari@df.uba.ar>
Reply-To: hgsolari@gmail.com
Organization: Universidad de Buenos Aires
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040113
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar> <46FCCD57.2020507@gmail.com>
In-Reply-To: <46FCCD57.2020507@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun

    netconsole, pritty nice debunging system... but (yes, there is 
always a but) it does not get to run.
    the method was well implemented, adding the acpi=off it sends the 
information to the receiving machine (I can even see passing a 
netconsole probing message in the machine under testing), but without 
turning off acpi it does not reach the point of loading and, 
consequently, it does not send a byte to the receiving machine.

Hence, result: empty output.

Hernan


-- 
Hernan G. Solari (solari@df.uba.ar http://www.df.uba.ar/~solari)
