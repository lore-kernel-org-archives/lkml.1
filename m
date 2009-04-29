Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbZD2GRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbZD2GRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZD2GRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:17:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42912 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZD2GR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:17:29 -0400
Date: Wed, 29 Apr 2009 09:17:22 +0300
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Quirk for BT USB device on MacbookPro to be reset
	before use
Message-ID: <20090429061722.GQ8611@everest>
Mail-Followup-To: Marcel Holtmann <marcel@holtmann.org>,
	List Linux Kernel <linux-kernel@vger.kernel.org>
References: <1240919876-6204-1-git-send-email-amit.kucheria@verdurent.com> <1240926166.997.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1240926166.997.7.camel@localhost.localdomain>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 06:42:46AM -0700, Marcel Holtmann wrote:
> 
> can you guys please NOT send out blindly outdated patches from your
> vendor kernel. Check if patches apply to Linus' kernel first and that
> they still make sense. In this case I have changed the BTUSB_RESET logic
> as default and marked the few old/broken devices as exception.

I stand suitably rebuked for good reason. Apologies. I will try not to repeat this mistake.

Regards,
Amit

-- 
------------------------------------------------------------
Amit Kucheria, Finland
------------------------------------------------------------
