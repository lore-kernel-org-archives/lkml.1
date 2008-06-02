Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYFBXzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYFBXzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYFBXz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:55:27 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:57840 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYFBXz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:55:26 -0400
Message-ID: <48448932.80803@keyaccess.nl>
Date: Tue, 03 Jun 2008 01:58:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, torvalds@linux-foundation.org,
       avuton@gmail.com, rene.herman@gmail.com, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>	<200806021605.14519.bjorn.helgaas@hp.com>	<3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>	<200806021642.50491.bjorn.helgaas@hp.com> <20080602164954.2aff2d77.akpm@linux-foundation.org>
In-Reply-To: <20080602164954.2aff2d77.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-06-08 01:49, Andrew Morton wrote:

> This broke
> pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch:

I expect the patch was meant solely for 2.6.26...

Bjorn, before you repost the option series due to this, wait a minute. 
Am now looking at/testing 14/15 and see some stuff that needs changing 
as well.

Rene
