Return-Path: <linux-kernel-owner+w=401wt.eu-S1033016AbXENMAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033016AbXENMAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032539AbXENL4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:56:52 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:33083 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762928AbXENL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:56:50 -0400
Date: Mon, 14 May 2007 13:57:12 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Reboot PATCH (ACPI related)
Message-ID: <20070514115712.GB3564@ics.muni.cz>
References: <20070512201006.GA3569@ics.muni.cz> <20070512234413.54fc6afa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070512234413.54fc6afa.akpm@linux-foundation.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-acpi@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 14 May 2007 13:56:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 11:44:13PM -0700, Andrew Morton wrote:
> We'd prefer to fix the problem, whatever it is, rather than just turning
> APCI off.
> 
> Please ensure that a full bug report has been entered at bugzilla.kernel.org,
> thanks.

The patch resulted from the following bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=6655

-- 
Luká¹ Hejtmánek
