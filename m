Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZCWPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZCWPsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbZCWPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:48:16 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:26443 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbZCWPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:48:15 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49C7AF3F.9090803@tremplin-utc.net>
Date: Mon, 23 Mar 2009 16:48:15 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] lis3: solve dependency between core and ACPI
References: <20090322234248.GG22927@buzzloop.caiaq.de> <1237765887-32672-1-git-send-email-daniel@caiaq.de> <1237765887-32672-2-git-send-email-daniel@caiaq.de>
In-Reply-To: <1237765887-32672-2-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> This solves the dependency between lis3lv02d.[ch] and ACPI specific
> methods. It introduces a ->bus_priv pointer to the device struct which
> is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> accordingly.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Cc: Eric Piel <eric.piel@tremplin-utc.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

Eric
