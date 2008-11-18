Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYKRO1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYKRO1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYKRO1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:27:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:34949 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968AbYKRO1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:27:17 -0500
Date: Tue, 18 Nov 2008 15:27:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Raphael Yoram Rubin <rafi@seas.upenn.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
In-Reply-To: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu>
Message-ID: <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz>
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Raphael Yoram Rubin wrote:

> Added quirks for the N-Trig digitizer.
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

Hi Raphael,

thanks a lot for the patch. The HID code has been refactored for 2.6.28, 
in order to make the support for quirky devices much more clean and 
prevent from turning of the HID code into unmaintainable mess full of 
randomly sprinkled quirks here and there.

Do you think you could rebase your patch on top of current 2.6.28-rc and 
resend it?

Thanks!

-- 
Jiri Kosina
SUSE Labs
