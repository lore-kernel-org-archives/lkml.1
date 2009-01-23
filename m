Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZAWRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZAWRwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZAWRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:52:05 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:35839 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZAWRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:52:04 -0500
Message-ID: <497A034F.6060303@caviumnetworks.com>
Date: Fri, 23 Jan 2009 09:50:07 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Walrond <andrew@walrond.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
References: <497A0164.90409@walrond.org>
In-Reply-To: <497A0164.90409@walrond.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2009 17:50:07.0417 (UTC) FILETIME=[07581290:01C97D83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Walrond wrote:
> Is anyone active in the serial code?
> 

Yes.

> [...]
> 
> The Machines are all amd64, various motherboards, identical distros 
> using 2.6.28.1 kernel.
> Either I have a particularly motley collection of kit, or the serial 
> code is in a pretty bad way.
> 

I use serial consoles on a variety of embedded boards every day (albeit 
mostly mips based) ,so I think it works.

You do have to have your kernel configured properly for a serial console 
for it to work right.

I would test it using some other device as the console.  Only once you 
have it working try for the serial console.

David Daney
