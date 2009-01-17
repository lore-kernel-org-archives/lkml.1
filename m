Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbZAQCNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbZAQCNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbZAQCNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:13:25 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:14847 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZAQCNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:13:25 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=6V8UYlqU7dT0cOAPPFoA:9 a=lvNORoJwPhrFLgUF5moA:7 a=N-pWVER_bjKnhL2JwJpO_hlna3wA:4 a=QTwTi9j1NaIA:10 a=9PoNLtlm7FgA:10
Message-ID: <49713EBF.2090600@shaw.ca>
Date: Fri, 16 Jan 2009 20:13:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Relson <relson@osagesoftware.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28 and Slab corruption: ext3_inode_cache
References: <20090116181702.1db3ca64@osage.osagesoftware.com>
In-Reply-To: <20090116181702.1db3ca64@osage.osagesoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Relson wrote:
> G'day,
> 
> I'm seeing a number of these messages, followed within minutes with my
> workstation freezing.  Attached is a copy of /var/log/messages from the
> first one (today at 13:50) to system freeze (at 14:09).  I've also
> attached the output of "zcat /proc/config.gz".  
> 
> Kernel:  2.6.28-gentoo
> 
> The hardware is:
> 
>   mobo:  ASUS M2A_VM
>   cpu:   AMD64 x2 5000
>   ram:   4GB Crucial Ballistics
>   hd:    Seagate ST3500320AS (SATA)
> 
> What additional info is needed?

Did you follow the messages' advice?

Jan 16 13:50:17 osage Single bit error detected. Probably bad RAM.
Jan 16 13:50:17 osage Run memtest86+ or a similar memory test tool.
