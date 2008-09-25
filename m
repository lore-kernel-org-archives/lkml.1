Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYIYQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYIYQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIYQi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:38:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYIYQiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:38:25 -0400
Date: Thu, 25 Sep 2008 12:13:00 -0400
From: Bill Nottingham <notting@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080925161300.GA17162@nostromo.devel.redhat.com>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <20080924183517.GA24209@nostromo.devel.redhat.com> <20080925091558.GE16734@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925091558.GE16734@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) said: 
> > (Alternatively, just remove them, of course...)
> 
> LOL :) Applied the commit below to tip/x86/debug, thanks Bill!

Does the 'kernel alive' right before it serve any purpose either?

Bill
