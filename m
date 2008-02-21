Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbYBUQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbYBUQQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbYBUQQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:16:30 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:41094 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbYBUQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:16:29 -0500
Message-ID: <47BDA46A.8050306@keyaccess.nl>
Date: Thu, 21 Feb 2008 17:18:50 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Adrian Bunk <bunk@kernel.org>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org
Subject: Re: pnp_bus_resume(): inconsequent NULL checking
References: <20080219224908.GM31955@cs181133002.pp.htv.fi> <200802200959.21814.bjorn.helgaas@hp.com> <47BD1069.1060109@keyaccess.nl> <200802210826.53731.bjorn.helgaas@hp.com>
In-Reply-To: <200802210826.53731.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-02-08 16:26, Bjorn Helgaas wrote:

> I'll push it upstream, but a coverity warning seems like a marginal
> excuse for putting it in 2.6.25.  Is there any real reason it can't
> wait until 2.6.26?

No, but we're only at -rc2. Dumb little things such as this needn't wait an 
entire development cycle I'd feel but I obviously don't feel strongly about 
the issue itself.

Rene.
