Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbXF2Vzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbXF2Vzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXF2VzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:55:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbXF2VzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:55:23 -0400
Date: Fri, 29 Jun 2007 22:54:16 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Turbo Fredriksson <turbo@bayour.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Moving MD/LVM from PPC to x86
Message-ID: <20070629215416.GA12786@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Turbo Fredriksson <turbo@bayour.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <87wsxneqs0.fsf@pumba.bayour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsxneqs0.fsf@pumba.bayour.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 11:02:39PM +0200, Turbo Fredriksson wrote:
>   2. How do I move a VG/PV/LV from PPC to x86?

The on-disk LVM2 metadata should be accessible from both
architectures.

Alasdair
-- 
agk@redhat.com
