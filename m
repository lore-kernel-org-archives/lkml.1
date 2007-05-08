Return-Path: <linux-kernel-owner+w=401wt.eu-S934998AbXEHQWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998AbXEHQWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934928AbXEHQWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:22:42 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:49760 "EHLO
	vitb.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934503AbXEHQWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:22:41 -0400
Date: Tue, 8 May 2007 20:19:59 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Samuel Ortiz <samuel@sortiz.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] 8xx: PQ SoC IRDA support
Message-ID: <20070508201959.339aca59@vitb.ru.mvista.com>
In-Reply-To: <522959B8-DDF1-4AA1-87AE-336793EDA181@kernel.crashing.org>
References: <20070508013044.6407.20509.stgit@localhost.localdomain>
	<522959B8-DDF1-4AA1-87AE-336793EDA181@kernel.crashing.org>
X-Mailer: Claws Mail 2.9.1cvs30 (GTK+ 2.6.10; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 08:33:19 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> > +			scc@a20 {
> > +				device_type = "network";
> > +				compatible = "fsl,irda";  
> 
> is this specific enough?  52xx also has irda and I'm guessing they'd  
> require different drivers (haven't looked).
Yap, I'll do "fsl,pq-irda" here...

-- 
Sincerely, 
Vitaly
