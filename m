Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYH0Nea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYH0Nea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYH0NeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:34:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYH0NeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:34:21 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: ak@linux.intel.com
Subject: Re: Introduce interface to report BIOS bugs (reworked, FW_BUG simple solution)
Date: Wed, 27 Aug 2008 15:34:18 +0200
User-Agent: KMail/1.9.9
Cc: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       linux-acpi@vger.kernel.org, ckornacker@suse.de
References: <200808210919.07642.bjorn.helgaas@hp.com> <1219843631-26015-1-git-send-email-trenn@suse.de>
In-Reply-To: <1219843631-26015-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271534.19715.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 15:27:08 Thomas Renninger wrote:
> Even simplier, using FW_BUG define. I agree that the first implementation
...
Ehh, this is not against ACPI test but latest Linus .27-rcX tree.
I hope/think it should still patch in both.

While this is fairly simple code, be aware that it's only compile tested.

    Thomas
