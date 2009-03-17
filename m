Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZCQR20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZCQR20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZCQR2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:28:16 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3130 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbZCQR2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:28:15 -0400
Date: Tue, 17 Mar 2009 18:28:11 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090317172811.GA33403@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain> <20090317081412.GA24115@elte.hu> <alpine.LFD.2.00.0903170831020.3082@localhost.localdomain> <20090317161322.GA25904@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317161322.GA25904@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 05:13:22PM +0100, Ingo Molnar wrote:
> That's why i could put the delta analysis there. We are capturing 
> thousands of measurement points, and what matters is the precision 
> of the 'pair' of (PIT,TSC) timestamp measurements.
> 
> I got roughly the same end result noise and the same anomalies with 
> tracing enabled and disabled. (and the number of data points was cut 
> in half with tracing enabled)

Any reason for not doing a bog-standard linear regression?

  OG.
