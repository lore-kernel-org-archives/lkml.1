Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZERVCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZERVCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZERVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 17:02:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34760 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZERVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 17:02:43 -0400
Date: Mon, 18 May 2009 22:02:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
	suspend
Message-ID: <20090518210241.GA17755@srcf.ucam.org>
References: <4A11C126.1000704@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A11C126.1000704@dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 03:12:22PM -0500, Mario Limonciello wrote:
>  Dell BT devices need to be removed from the bus and reinserted
>  so that userspace udev rules can transition the devices into the
>  proper mode after S3 or S4.

This sounds wrong. What kind of reinitialisation are you talking about?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
