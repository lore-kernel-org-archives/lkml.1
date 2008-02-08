Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbYBHCE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbYBHCE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762152AbYBHCEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:04:07 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:58862 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbYBHCEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:04:06 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Fri, 8 Feb 2008 02:02:40 +0000
User-Agent: KMail/1.9.7
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <200802080119.08872.carlos@strangeworlds.co.uk> <2c0942db0802071738g2f426d4y6ee9ab58b62d8174@mail.gmail.com>
In-Reply-To: <2c0942db0802071738g2f426d4y6ee9ab58b62d8174@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080202.41355.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Fri, 08 Feb 2008 02:02:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 01:38:01 Ray Lee wrote:
> <nod> That's clear to me (whereas the original wasn't), though I would
> still argue for this driver being select'ed by the drivers that
> require it. As you note, other laptop specific drivers do so, and
> Linus has come down in favor of that as well in the past, so you have
> a friend in high places :-).

I have some other patches lined up to do so. Unless I hear some arguments
against it, or some better alternatives, I'll put them together with this
and get Len to apply them to the ACPI tree (and then hopefully push back
out before the -rc1 release).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
