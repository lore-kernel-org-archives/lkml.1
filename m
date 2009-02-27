Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZB0Pcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZB0Pcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZB0Pcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:32:43 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:6753 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZB0Pcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:32:43 -0500
Message-ID: <49A80796.2070208@turknet.net.tr>
Date: Fri, 27 Feb 2009 17:32:38 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Diego Calleja <diegocg@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
References: <49A659D0.2040903@turknet.net.tr> <200902261802.56612.diegocg@gmail.com>
In-Reply-To: <200902261802.56612.diegocg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2009 15:32:40.0079 (UTC) FILETIME=[A00169F0:01C998F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> Isn't this what kdump does right now? http://lwn.net/Articles/108595/
>   

Yep, very similar to "kdump". But, kdump is too simple. Backup kernel is 
just so minimal and only to handle crash dump thing. With "Failover 
kernel", I'm talking about fully functional backup kernel like primary 
one. Not just too minimally functioning crash dump kernel.
