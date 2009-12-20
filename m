Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZLTTZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZLTTZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZLTTZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:25:22 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:18605 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZLTTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:25:18 -0500
Date: Sun, 20 Dec 2009 12:25:17 -0700
From: Alex Chiang <achiang@hp.com>
To: venkatesh.pallipadi@intel.com, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] ACPI: early _PDC eval and unify x86/ia64
Message-ID: <20091220192517.GA2016@ldl.fc.hp.com>
References: <20091220190434.4274.67855.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220190434.4274.67855.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> It was recently discovered that some BIOS implementations load
> dynamic SSDTs when a processor's _PDC method is evaluated.

D'oh, I knew I'd forget something. Here are some bz references:

	http://bugzilla.kernel.org/show_bug.cgi?id=14824
	http://bugzilla.kernel.org/show_bug.cgi?id=14710

/ac

