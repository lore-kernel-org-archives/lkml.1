Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYFGKNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYFGKNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYFGKNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:13:40 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:49054 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbYFGKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:13:39 -0400
X-Greylist: delayed 814 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 06:13:39 EDT
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RESEND: [PATCH 3/3] Misc: Add HP WMI laptop extras driver
Date: Sat, 7 Jun 2008 11:00:02 +0100
User-Agent: KMail/1.9.9
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080528132900.GC32646@srcf.ucam.org>
In-Reply-To: <20080528132900.GC32646@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806071100.03097.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sat, 07 Jun 2008 10:00:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008 14:34:25 Matthew Garrett wrote:
> This driver adds support for reading and configuring certain information
> on modern HP laptops with WMI BIOS interfaces. It supports enabling and
> disabling the ambient light sensor, querying attached displays and hard
> drive temperature, sending events on docking and querying the state of
> the dock and toggling the state of the wifi, bluetooth and wwan hardware
> via rfkill. It also makes the little "(i)" button work on machines that
> send that via WMI rather than via the keyboard controller.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

For the ACPI-WMI bits:

Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
