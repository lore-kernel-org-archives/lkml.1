Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbYEPUjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbYEPUjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYEPUjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:39:35 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59545 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbYEPUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:39:34 -0400
Date: Fri, 16 May 2008 16:39:33 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20080516203932.GH27126@csclub.uwaterloo.ca>
References: <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca> <20080516161029.44ded734@core> <20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46f59ad6@core> <20080516184138.GF27126@csclub.uwaterloo.ca> <20080516210445.6f961627@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516210445.6f961627@core>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 09:04:45PM +0100, Alan Cox wrote:
> So open /dev/urandom in that case. It's a user space problem - this is
> policy.

How does user space know?  Maybe someone is using the serial console,
maybe not.

-- 
Len Sorensen
