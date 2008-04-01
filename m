Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYDAAWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYDAAWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 20:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYDAAWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 20:22:11 -0400
Received: from mail.lang.hm ([64.81.33.126]:40201 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYDAAWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 20:22:10 -0400
Date: Mon, 31 Mar 2008 17:28:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803310440.33019.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803311727500.31200@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <47DFBD99.2080501@davidnewall.com> <alpine.DEB.1.00.0803180933230.21250@asgard.lang.hm> <200803310440.33019.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Daniel Phillips wrote:

> On Tuesday 18 March 2008 09:36, david@lang.hm wrote:
>> P.S. 8xPCI-e slots are only able to do 2GB/s of data transfer, in an
>> earlier post Daniel claimed that you needed 3GB/s of disk to mirror to the
>> disk, so the scenerio listed above looses 1/3 of it's performance compared
>> to what was being claimed earlier.
>
> Each Violin 1010 has two 8xPCI-e interfaces.

but if you use them for redundancy by hooking them to two machines you can 
only use one of them on your active system.

David Lang
