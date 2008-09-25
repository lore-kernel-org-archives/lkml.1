Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYIYKIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYIYKIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYIYKHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:07:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40786 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYIYKHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:07:51 -0400
Date: Thu, 25 Sep 2008 11:07:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: carbonated beverage <ramune@net-ronin.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_ACPI_VIDEO on Thinkpad blanks display.
Message-ID: <20080925100746.GA13185@srcf.ucam.org>
References: <20080925060244.GA18945@net-ronin.org> <20080925070741.GA22376@net-ronin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925070741.GA22376@net-ronin.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 12:07:41AM -0700, carbonated beverage wrote:

> Without CONFIG_ACPI_VIDEO, the above message don't appear.  From this point,
> any pointers on figuring out why the ACPI features makes the screen go blank?

Yes. X assumed that any ACPI key press was a request to switch the video 
output. Upgrade X.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
