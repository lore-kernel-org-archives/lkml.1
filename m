Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYBTKXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYBTKXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYBTKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:23:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:39011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYBTKX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:23:27 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [2/5] Use 2000 offset for 32bit kernels
Date: Wed, 20 Feb 2008 11:23:23 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080209416.271135970@suse.de> <alpine.LFD.1.00.0802162024220.7583@apollo.tec.linutronix.de> <alpine.LFD.1.00.0802201049310.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802201049310.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201123.23830.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 11:07:02 Thomas Gleixner wrote:
> On Sat, 16 Feb 2008, Thomas Gleixner wrote:
> > On Sat, 9 Feb 2008, Andi Kleen wrote:
> > > 
> > > We know it is already after 2000.
> > > 
> > > This extends the effective lifetime of 32bit systems by 8 years:
> > > from 2030 to 2038.
> 
> Could you please explain what magic math does the 2030 -> 2038
> extension ?

Hmm, yes on rechecking I also don't know how I got the original
conclusion.

-Andi

