Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYHLX3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYHLX3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHLX32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:29:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbYHLX32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:29:28 -0400
Date: Tue, 12 Aug 2008 16:28:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: alan-jenkins@tuffmail.co.uk, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br,
       Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other
 GPEs) on Asus EeePC
Message-Id: <20080812162854.d6907c95.akpm@linux-foundation.org>
In-Reply-To: <487F9677.4060001@suse.de>
References: <487D23C3.5070301@student.cs.york.ac.uk>
	<487F58B6.5040309@suse.de>
	<487F6D2E.2040501@tuffmail.co.uk>
	<487F772C.1070806@suse.de>
	<487F9592.1060003@tuffmail.co.uk>
	<487F9677.4060001@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Did this get fixed yet?

I have an patch in -mm which I just restored (I had to tempdrop it
because the acpi tree was busted for some time).  But it seems to be
old.

http://bugzilla.kernel.org/show_bug.cgi?id=10919 is marked "resolved"
but the reporter (Maximilian) seems to think otherwise.  2.6.26.x is,
afaik, still unfixed, as is 2.6.27-rc.

Thanks.
