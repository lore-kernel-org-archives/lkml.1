Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbZC0AC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbZC0AC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762268AbZC0ACF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:02:05 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:61761 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762316AbZC0ACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:02:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Santiago Garcia Mantinan <manty@manty.net>
Subject: Re: uli526x hangs on 2.6.29, not on rc8
Date: Fri, 27 Mar 2009 01:01:58 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090326231515.GA6612@dis.manty.net>
In-reply-To: <20090326231515.GA6612@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903270102.00104.elendil@planet.nl>
X-OriginalArrivalTime: 27 Mar 2009 00:02:00.0991 (UTC) FILETIME=[40E1C2F0:01C9AE6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manty,

Santiago Garcia Mantinan wrote:
> After upgrading from rc8 to final 2.6.29 my machine's network stops
> working after some full speed (100Mb/s) downloads ifdown;ifup, or
> powering off the switch won't solve the problem, however it is solved if
> I unload the driver module and load it again. Tested with another NIC
> (e1000e based) and couldn't reproduce the problem.

Known issue probably. Try: http://lkml.org/lkml/2009/3/25/217

Cheers,
FJP
