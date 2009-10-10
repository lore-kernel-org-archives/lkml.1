Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbZJJBpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbZJJBpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbZJJBpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:45:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:54973 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680AbZJJBpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,535,1249282800"; 
   d="scan'208";a="197268777"
Subject: Re: [RFC] [PATCH 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
In-Reply-To: <4ACF4B26.5080604@gmail.com>
References: <1253590755.15763.21.camel@rzhang-dt>
	 <4AB8C62F.5020605@cam.ac.uk>  <4ACF4B26.5080604@gmail.com>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 09:43:28 +0800
Message-Id: <1255139008.25209.2.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc Greg

On Fri, 2009-10-09 at 22:39 +0800, Jonathan Cameron wrote:
> Hi Zhang,
> 
> Do you have any thoughts on merge route for this?
> I've just posted the tsl2550 port to als and it is bound to come
> up in that thread.
> 
no.
I think we can queue this patch set for 2.6.33.

thanks,
rui


