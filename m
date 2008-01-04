Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYADMIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYADMIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYADMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:08:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54499 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbYADMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:08:37 -0500
Date: Fri, 4 Jan 2008 13:07:58 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Ben Dooks <ben@fluff.org>, linux-kernel@vger.kernel.org,
       bryan.wu@analog.com
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080104130758.6ce74a68@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080104054802.40325b15@zod.rchland.ibm.com>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	<20080103160406.7ef5ecfe@zod.rchland.ibm.com>
	<20080103224139.GA4178@fluff.org.uk>
	<20080103165854.0d6accef@zod.rchland.ibm.com>
	<20080104040119.GA10268@linux-sh.org>
	<20080104091928.GA28547@flint.arm.linux.org.uk>
	<20080104103345.GA15184@linux-sh.org>
	<20080104054802.40325b15@zod.rchland.ibm.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(removed hskinnemoen@amtel.com from Cc since it's misspelled. Thanks, Paul)

On Fri, 4 Jan 2008 05:48:02 -0600
Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:

> Rework the architecture specific Makefiles to use the in-kernel version of
> the mkubootimg tool.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
