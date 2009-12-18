Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbZLRUKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbZLRUKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZLRUK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:10:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:55314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbZLRUK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:10:26 -0500
Message-ID: <4B2BE174.2040307@kernel.org>
Date: Fri, 18 Dec 2009 12:09:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 0/7] x86/pci: amd_bus and intel_bus
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try to enable them for one chain and 32bit

need apply them after first two patches in "early_res range bootmem"

Thanks

Yinghai


