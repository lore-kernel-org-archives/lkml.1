Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYHRRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYHRRWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYHRRWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:22:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36699 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYHRRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:22:12 -0400
Date: Mon, 18 Aug 2008 13:17:49 -0400
From: Dave Jones <davej@redhat.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Ingo Molnar <mingo@elte.hu>, David Fries <david@fries.net>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818171749.GA18771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Ingo Molnar <mingo@elte.hu>, David Fries <david@fries.net>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080818152440.GA26134@redhat.com> <20080818160426.GD12476@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818160426.GD12476@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 12:04:26PM -0400, Lennart Sorensen wrote:
 > On Mon, Aug 18, 2008 at 11:24:40AM -0400, Dave Jones wrote:
 > > Is this part really necessary ?
 > > 
 > > Why would a 486 be in EFI code?
 > 
 > Someone has a hobby writing replacement firmware for their 486?

Anyone who writes EFI code for a hobby really needs to see
a mental health specialist.

	Dave

-- 
http://www.codemonkey.org.uk
