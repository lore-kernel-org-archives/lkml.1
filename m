Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbXENTAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbXENTAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXENTAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:00:35 -0400
Received: from www.osadl.org ([213.239.205.134]:48434 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbXENTAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:00:34 -0400
Subject: Re: [PATCH][RFC] Remove final vestiges of interrupt-related "SA_"
	flags.
From: Thomas Gleixner <tglx@linutronix.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705141433490.14658@localhost.localdomain>
References: <Pine.LNX.4.64.0705141433490.14658@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 14 May 2007 21:03:54 +0200
Message-Id: <1179169434.7074.9.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 14:38 -0400, Robert P. J. Day wrote:
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 498ff31..c5d7775 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -160,15 +160,6 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
> 
>  ---------------------------
> 
> -What:	Interrupt only SA_* flags
> -When:	September 2007
> -Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
> -	out of the signal namespace.
> -
> -Who:	Thomas Gleixner <tglx@linutronix.de>
> -

NAK, the removal date is September 2007 so out of tree folks have some
time to fix their crap.

	tglx


