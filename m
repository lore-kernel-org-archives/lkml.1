Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZA0Wtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZA0Wtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZA0Wtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:49:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZA0Wtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:49:36 -0500
Message-ID: <497F8F7A.10601@zytor.com>
Date: Tue, 27 Jan 2009 14:49:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fix asm constraints in vesa_store_edid
References: <jer62oxyt6.fsf@sykes.suse.de>
In-Reply-To: <jer62oxyt6.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> As the comment explains, the VBE DDC call can clobber any register.
> Tell the compiler about that fact.
> 
> Signed-off-by: Andreas Schwab <schwab@suse.de>

Applied to tip:x86/setup-v2; it should be in linux-next in the next day 
or two.

Thanks!

	-hpa
