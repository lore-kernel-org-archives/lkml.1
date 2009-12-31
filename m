Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZLaQlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZLaQlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 11:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZLaQlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 11:41:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6137 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZLaQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 11:41:49 -0500
Date: Thu, 31 Dec 2009 17:37:19 +0100
From: Anisse Astier <anisse@astier.eu>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       len.brown@intel.com
Subject: Re: [2.6.33{rc2-git1,2}]: hp-wmi again broken
Message-ID: <20091231173719.6fee3a68@destiny.ordissimo>
In-Reply-To: <2d0a357f0912310817p3b828239qc81994973fca1274@mail.gmail.com>
References: <2d0a357f0912310817p3b828239qc81994973fca1274@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

On Thu, 31 Dec 2009 17:17:43 +0100, Sedat Dilek <sedat.dilek@googlemail.com> wrote :

> Hi,
> 
> I am not sure why this bug has re-entered from linux-acpi-2.6 to
> linux-kernel, but I just wanted to report Anisse has re-send a fix for
> hp-wmi [1].
> The original bug was reported with appended patch in [2].
> From 2.6.33-rc2 to 2.6.32-git2 hp-wmi is still broken.
> Please, fix that cleanly in upstream, now.
> Thanks.
> 
> Kind Regards,
> - Sedat -
> 
> [1] ACPI & driver patches for 2.6.33-rc2
> http://patchwork.kernel.org/patch/70398/
> [2] [2.6.33-rc2] ACPI problems on HP nc6400 notebook
> http://patchwork.kernel.org/patch/69745/

It would be nice if you could test the patch I sent, so that we had a
confirmation it's working. It's a (trivial)one-liner, but it was also a
one-liner that introduced the regression.

Thanks in advance.

Anisse

