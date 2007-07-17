Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbXGQLiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbXGQLiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXGQLhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:37:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:47825 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbXGQLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:37:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Date: Tue, 17 Jul 2007 13:31:59 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, akpm@osdl.org
References: <20070716180019.GA5112@google.com>
In-Reply-To: <20070716180019.GA5112@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171331.59414.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 20:00:19 Aaron Durbin wrote:
> 
> Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.

Why? I had such a patch at some point as experiment, but it never
helped actually fix a box.

-Andi
