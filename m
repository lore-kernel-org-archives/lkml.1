Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXI2KTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXI2KTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXI2KTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:19:36 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:54736 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752588AbXI2KTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:19:36 -0400
Date: Sat, 29 Sep 2007 12:19:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>, <i2c@lm-sensors.org>
Subject: Re: [PATCH 2.6.23-rc4][reRESEND] i2c-i801: SMBus patch for Intel
 Tolapai
Message-ID: <20070929121932.50c7bfda@hyperion.delvare>
In-Reply-To: <39B20DF628532344BC7A2692CB6AEE0701CF2CA9@orsmsx420.amr.corp.intel.com>
References: <200708302042.59104.jason.d.gaston@intel.com>
	<20070831175045.37938669@hyperion.delvare>
	<39B20DF628532344BC7A2692CB6AEE0701CF2CA9@orsmsx420.amr.corp.intel.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Fri, 28 Sep 2007 15:09:16 -0700, Gaston, Jason D wrote:
> The pci_ids.h file is updated in 2.6.23-rc8.  Can you push this
> i2c-i801.c patch?

This patch has been in -mm since 2.6.23-rc7-mm1. It will go into Linus'
tree shortly after 2.6.23 is released. This is not a bug fix, so I
can't push it into 2.6.23.

-- 
Jean Delvare
