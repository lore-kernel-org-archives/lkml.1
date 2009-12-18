Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbZLRU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbZLRU4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbZLRU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:56:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:52615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbZLRUz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:55:58 -0500
Message-ID: <4B2BEC0E.3050909@kernel.org>
Date: Fri, 18 Dec 2009 12:54:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 0/12] pci: update pci bridge resources
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this patche set is trying to update pci bridge BAR when that BAR is big enough.

default it is disabled.

could use pci=try=2 to enable it.

Thanks

Yinghai


