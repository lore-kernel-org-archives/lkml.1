Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYBSNEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYBSNEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBSNEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:04:31 -0500
Received: from styx.suse.cz ([82.119.242.94]:45683 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752805AbYBSNEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:04:30 -0500
Date: Tue, 19 Feb 2008 14:04:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Adolfo R. Brandes" <arbrandes@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <Pine.LNX.4.64.0802191333050.30955@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0802191403400.30955@jikos.suse.cz>
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com> 
 <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz> 
 <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com> 
 <b4292e150801180958v43350590pc6ed4683bfc478ab@mail.gmail.com> 
 <Pine.LNX.4.64.0802112115580.7699@twin.jikos.cz> 
 <b4292e150802120523o7e44500as9be841618805e54e@mail.gmail.com>
 <b4292e150802120709u1ac16800l11366913a0b54a8@mail.gmail.com>
 <Pine.LNX.4.64.0802191333050.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Jiri Kosina wrote:

> but only the "release" report, that is sent just afterwards, seems to have 
> reached HID layer, I don't know why. Could you please test the patch 
> below, and send me the output?

BTW the patch is against 2.6.25-rc2, it won't apply to pre-2.6.25-rcX 
kernels, due to reworks that happenned in this code.

-- 
Jiri Kosina
SUSE Labs
