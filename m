Return-Path: <linux-kernel-owner+w=401wt.eu-S934160AbYBHJil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbYBHJil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbYBHJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:38:29 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:50478 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbYBHJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:38:28 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Fri, 8 Feb 2008 09:37:33 +0000
User-Agent: KMail/1.9.7
Cc: Ray Lee <ray-lk@madrabbit.org>, Len Brown <lenb@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <200802080027.54576.carlos@strangeworlds.co.uk> <20080208065312.GA4341@ucw.cz>
In-Reply-To: <20080208065312.GA4341@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080937.35225.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Fri, 08 Feb 2008 09:37:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 06:53:13 Pavel Machek wrote:
> I believe selct is the way to go here. What do acer-wmi handle?
> Additional buttons? Leds? Temperatures? Fan states?

Enabling wireless, bluetooth and 3G; and exposing the mail LED and backlight.

tc1100-wmi handles wireless and the jog dial, IIRC.

> The laptops will boot fine without it, right?

Yes.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
