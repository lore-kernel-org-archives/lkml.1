Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbZBXQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbZBXQdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZBXQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:33:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZBXQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:33:47 -0500
Date: Tue, 24 Feb 2009 17:51:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Salman Qazi <sqazi@google.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Performance regression in write() syscall
Message-ID: <20090224165154.GX26292@one.firstfloor.org>
References: <20090224020304.GA4496@google.com> <20090224100913.GU26292@one.firstfloor.org> <20090224161329.GA26299@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224161329.GA26299@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks everyone for the correction. I indeed misread the patch.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
