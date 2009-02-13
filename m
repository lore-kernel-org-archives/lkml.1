Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbZBMVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbZBMVQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760455AbZBMVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:16:11 -0500
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:45899 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760421AbZBMVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:16:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ffnOGKtegz0bjLrDhNHE1aS/K31anyzy3ApwYUSHob8Fz92+yoVtwbp5zewTn/G51QIAg/P7WPEDf0UVRlRl0AdL54tFRnLaDcOV+ZfuVhzV6QF0HQdm9R3tFesZ1nZY;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCHv3] PCI: add missing KERN_* constants to printks
Date: Fri, 13 Feb 2009 13:16:04 -0800
User-Agent: KMail/1.9.10
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       greg@kroah.com, kristen.c.accardi@intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
       fenghua.yu@intel.com, akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Taku Izumi <izumi.taku@jp.fujitsu.com>
References: <498B2116.6010707@suse.de> <498C0198.3020408@suse.de>
In-Reply-To: <498C0198.3020408@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131316.06701.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 1:23 am Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
>
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the pci subsystem.
>
> Signed-off-by: Frank Seidel <frank@f-seidel.de>

Applied to my linux-next branch, thanks Frank.

-- 
Jesse Barnes, Intel Open Source Technology Center
