Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYAPHir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYAPHir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbYAPHij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:38:39 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36336 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYAPHii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:38:38 -0500
Date: Wed, 16 Jan 2008 08:38:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: What's in sh-2.6.git for 2.6.25?
Message-ID: <20080116073844.GA25205@uranus.ravnborg.org>
References: <20080116070403.GA14107@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116070403.GA14107@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 04:04:03PM +0900, Paul Mundt wrote:
> This is a brief summary of the changes that are sitting in the sh queue
> for 2.6.25.
> 
> The main points to note are as follows:
> 
> 	- sh64->sh integration.
> 	- A handful of new CPUs (SH7721, SH7763, SH7203, SH7263).
> 	- SH-2A FPU support.
> 	- Board support updates (R2D, R7785RP).
> 
> The sh64->sh integration is basically the only thing that's really
> interesting, and so it's worth summarizing that a bit.

Any kbuild bits that needs an extra pair of eyes before
integration or can I postpone my review until it hits mainline?
If you feel confident I prefer to wait as I'm busy atm.

	Sam
