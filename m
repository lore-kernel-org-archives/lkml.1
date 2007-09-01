Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXIAKO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXIAKO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXIAKON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:55556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbXIAKOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:14:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [patch 1/5] x86: Add AMD64 Barcelona PMU MSR definitions
Date: Sat, 1 Sep 2007 12:14:01 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <20070830174311.344418000@amd.com>
In-Reply-To: <20070830174311.344418000@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709011214.02063.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 19:43:12 Robert Richter wrote:
> Already added to the -mm tree.  Its filename is
>      i386-add-amd64-barcelona-pmu-msr-definitions.patch


Patch doesn't apply to -rc5 + ff tree.

Hunk #1 FAILED at 73.
Hunk #2 FAILED at 107.
2 out of 2 hunks FAILED -- rejects in file include/asm-i386/msr-index.h

If you want to do random white space changes and
code movement please do it in a separate patch in the future.

-Andi
