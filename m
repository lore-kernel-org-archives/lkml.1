Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbZBFJRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbZBFJRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZBFJQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:16:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:41217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZBFJQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:16:41 -0500
Message-ID: <498BFFDE.40806@suse.de>
Date: Fri, 06 Feb 2009 10:16:14 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, greg@kroah.com, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <498B29CC.2030000@suse.de> <498BFC67.6030701@jp.fujitsu.com>
In-Reply-To: <498BFC67.6030701@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taku Izumi wrote:
>   Why didn't you retouch the following dev_printk ?

Yes, good question. Thanks for the pointer.. that should
then of course also be changed.

Thanks,
Frank
