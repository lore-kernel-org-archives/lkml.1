Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbXGPHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbXGPHjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXGPHiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:38:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:52452 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXGPHiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:38:52 -0400
Date: Mon, 16 Jul 2007 09:38:44 +0200
From: Stefan Seyfried <seife@suse.de>
To: rzhang1 <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] ACPI: update ACPI_PROCFS removal schedule
Message-ID: <20070716073844.GB23083@suse.de>
References: <1184235634.6286.2.camel@rzhang1-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1184235634.6286.2.camel@rzhang1-laptop>
X-Operating-System: openSUSE 10.3 (i586) Alpha5plus, Kernel 2.6.22-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 06:20:34PM +0800, rzhang1 wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> ACPI sysfs conversion is not finished yet and
> some user space tools still depend on the ACPI procfs I/F.
> 
> The ACPI_PROCFS removal schedule is changed to Jan 08.

I think that's too early. The conversion to sysfs is not even
finished, so it will be less than 6 months.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
