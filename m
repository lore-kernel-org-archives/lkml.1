Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYA3NSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYA3NSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbYA3NSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:18:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760003AbYA3NSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:18:07 -0500
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
       Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
Date: Wed, 30 Jan 2008 14:18:04 +0100
In-Reply-To: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu> (Bruce Allen's message of "Wed\, 30 Jan 2008 03\:51\:51 -0600 \(CST\)")
Message-ID: <p73ve5b5u5v.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Allen <ballen@gravity.phys.uwm.edu> writes:

> Dear LKML,

You forgot to specify what user programs you used to get to the
benchmark results. e.g. if the user space does not use large 
enough reads/writes then performance will be not optimal.

Also best you repost your results with full information
on netdev@vger.kernel.org

-Andi
