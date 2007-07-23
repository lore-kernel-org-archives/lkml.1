Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXGWAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXGWAa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762931AbXGWAaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:30:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:42716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762596AbXGWAaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:30:21 -0400
From: Andi Kleen <ak@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
Date: Mon, 23 Jul 2007 02:29:10 +0200
User-Agent: KMail/1.9.1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       joachim.deguara@amd.com
References: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com> <200707221452.27002.ak@suse.de> <86802c440707221554p3866fdc8j34f49825162dbf1f@mail.gmail.com>
In-Reply-To: <86802c440707221554p3866fdc8j34f49825162dbf1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230229.10918.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> you will need to force every BIOS to have correct SRAT table.

They are normally correct. I'm not aware of wrong SRAT tables
in production systems.

-Andi
