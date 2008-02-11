Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYBKQEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYBKQEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYBKQEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:04:45 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51208 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbYBKQEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:04:44 -0500
Subject: Re: [PATCH] drivers/base: export gpl (un)register_memory_notifier
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, linux-ppc <linuxppc-dev@ozlabs.org>,
       Thomas Klein <osstklei@de.ibm.com>,
       "Themann, Jan-Bernd" <themann@de.ibm.com>, Greg KH <greg@kroah.com>,
       Christoph Raisch <RAISCH@de.ibm.com>
In-Reply-To: <200802111657.07534.ossthema@de.ibm.com>
References: <200802111657.07534.ossthema@de.ibm.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 08:04:43 -0800
Message-Id: <1202745883.8276.5.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 16:57 +0100, Jan-Bernd Themann wrote:
> Drivers like eHEA need memory notifiers in order to 
> update their internal DMA memory map when memory is added
> to or removed from the system.

Could you post this with the new users as well so we can make sure
they're not abusing this in some way?

-- Dave

