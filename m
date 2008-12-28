Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYL1O6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYL1O6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 09:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYL1O6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 09:58:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35185 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYL1O6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 09:58:39 -0500
Date: Sun, 28 Dec 2008 14:58:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: corentincj@iksaif.net, linux-kernel@vger.kernel.org, len.brown@intel.com
Subject: Re: Patch enabling Bluetooth for Asus EEE 901
Message-ID: <20081228145835.GB12853@srcf.ucam.org>
References: <20081228102026.GA18096@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228102026.GA18096@localhost>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 11:20:27AM +0100, Ondrej Zajicek wrote:
> eeepc-laptop driver has interface for enabling/disabling
> Bluetooth, but it does not work. This patch fixes it.

An identical patch was posted at the start of the month in 
<20081203203111.GA28234@earth.li> - Len, are you picking up patches from 
-acpi at the moment, or do they need to be sent to you as well?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
