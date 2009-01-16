Return-Path: <linux-kernel-owner+w=401wt.eu-S1763743AbZAPQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763743AbZAPQTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbZAPQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:19:14 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:36863 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZAPQTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:19:13 -0500
Message-ID: <4970B37D.2040508@turknet.net.tr>
Date: Fri, 16 Jan 2009 18:19:09 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Btrfs Snapshot Removal And General Project Status
References: <496DC1C6.7090307@turknet.net.tr> <1232119011.21473.24.camel@think.oraclecorp.com>
In-Reply-To: <1232119011.21473.24.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 16:19:09.0388 (UTC) FILETIME=[2936B0C0:01C977F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> Sorry for the delay, I missed this one somehow.
Oh,it's really no problem. ;-)  All we know that you're too busy 
nowadays, cause of btrfs' mainline inclusion. :-)
> That's right.  You did rm -rf dir, which is actually the slowest
> possible way to remove the snapshot ;)  A much more optimized version is
> possible, and already implemented as part of transaction commit.
>
>   
Thanks for pointing ;-)

> A very good point, I'm in the process of documenting this better.
>
>   
Good luck! :-)


Tarkan ERIMER
