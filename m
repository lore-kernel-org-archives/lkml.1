Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbZAUBSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbZAUBSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZAUBRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:17:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45552 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbZAUBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:17:52 -0500
Message-ID: <497677A6.7000107@jp.fujitsu.com>
Date: Wed, 21 Jan 2009 10:17:26 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
References: <200901131457.58164.rjw@sisk.pl> <49744142.2060806@jp.fujitsu.com> <200901210116.09211.rjw@sisk.pl> <200901210118.44162.rjw@sisk.pl>
In-Reply-To: <200901210118.44162.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks,
H.Seto

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce new function pci_msix_table_size() returning the size of
> the MSI-X table of given PCI device or 0 if the device doesn't
> support MSI-X.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---



