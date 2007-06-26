Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbXFZOE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbXFZOE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXFZOET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:04:19 -0400
Received: from gw.goop.org ([64.81.55.164]:39589 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561AbXFZOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:04:17 -0400
Message-ID: <46811CAD.3020209@goop.org>
Date: Tue, 26 Jun 2007 10:03:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: dave young <hidave.darkstar@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: i386 boot fail, EIP in __change_page_attr:166
References: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>
In-Reply-To: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dave young wrote:
> Hi,
> I reconfig my kernel, boot and oops, EIP in __change_page_attr:166, I
> tried 2.6.22-rc4-mm2 and 2.6.22-rc5 , same result.

oops output?  dmesg output?  Hardware config?  How much memory?  How big 
is your kernel?

    J
