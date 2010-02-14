Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0BNQzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 11:55:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40292 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BNQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 11:55:31 -0500
Date: Sun, 14 Feb 2010 16:55:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Erik Andren <erik.andren@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] platform/x86/dell-laptop: Add another Dell laptop
	to the DMI whitelist
Message-ID: <20100214165528.GA25624@srcf.ucam.org>
References: <1266144897-2681-1-git-send-email-erik.andren@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266144897-2681-1-git-send-email-erik.andren@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:54:57AM +0100, Erik Andren wrote:
> The Latitude C640 has another variation of dell in its DMI vendor entry.
> Add it to the whitelist in order to enjoy the sweet fruits of software backlight toggling.

Thanks, picked up for .34.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
