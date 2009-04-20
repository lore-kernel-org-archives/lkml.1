Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZDTSX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZDTSX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZDTSXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:23:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48226 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZDTSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:23:15 -0400
Date: Mon, 20 Apr 2009 19:23:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add support for Eject hotkey in dell-wmi
Message-ID: <20090420182312.GA2910@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ECBAE2.2080308@dell.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 01:11:46PM -0500, Mario Limonciello wrote:
> Hi:
> 
> I've gotten word that future Dell consumer laptops are transitioning
> several hotkeys to WMI instead.  Here's a patch to enable the first to
> enable the Eject hotkey.  I'm attaching it since my mail server
> (exchange) would mangle it otherwise.

Looks good - can you confirm that it'll be removed from the normal 
keyboard interface at the same time?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
