Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYKFWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYKFWXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYKFWXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:23:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbYKFWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:23:08 -0500
Date: Thu, 6 Nov 2008 14:22:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: pavel@suse.cz, trenn@suse.de, burman.yan@gmail.com, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, len.brown@intel.com, kasievers@suse.de,
       hmh@hmh.eng.br
Subject: Re: leds-hp-disk vs lis3lv02d
Message-Id: <20081106142240.763e1276.akpm@linux-foundation.org>
In-Reply-To: <49136561.1050907@tremplin-utc.net>
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org>
	<4902F817.4050108@tremplin-utc.net>
	<20081026174023.GA1847@ucw.cz>
	<200810271345.04961.trenn@suse.de>
	<20081106121405.GA1601@ucw.cz>
	<49136561.1050907@tremplin-utc.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 22:45:05 +0100
__ric Piel <Eric.Piel@tremplin-utc.net> wrote:

> Andrew, is there anything preventing the merge of the lis3lv02d driver 
> from your tree to Linus' one?

Nope.  I have a number of shiny new drivers which I plan to send in for
2.6.28 (I sent an fbdev one this morning).  I need to get down and do a
sweep to round tham all up.
