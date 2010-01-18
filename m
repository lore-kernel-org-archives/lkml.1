Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160Ab0ARVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0ARVqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067Ab0ARVqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:46:18 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52746 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab0ARVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:46:18 -0500
Subject: Re: [PATCH] Rename rar_driver to rar_register
From: Marcel Holtmann <marcel@holtmann.org>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
In-Reply-To: <1263849696-23060-1-git-send-email-mark.a.allyn@intel.com>
References: <1263849696-23060-1-git-send-email-mark.a.allyn@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 13:45:58 -0800
Message-ID: <1263851158.5591.147.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> The purpose of this patch is to change the name of rar_register source
> files (both the .c and .h files) to rar_register.
> 
> This is the first of seven patches for the rar_register driver
> for Sunday, January 17, 2009
> 
> This is to clarify that this driver is for the rar_register.
> 
> This patch only changes the names. It does not make any changes in
> any code.
> 
> Any checkpatch errors on this code were from the original code. They
> will be addressed in future patches.
> 
> The rar stands for restricted access region. The restricted access
> region is an area of memory that can be locked from access by the
> x86 processor.
> 
> The purpose of the restricted access region is to safeguard confidential
> information from any unauthorized software running on the x86 processor.
> 
> The purpose of this driver is to enable other drivers to obtain
> the address ranges of the restricted regions as well as lock them.
> 
> This patch is referenced off the linux-next repository as pulled
> on Sunday, January 17, 2010

this is a lot of boilerplate that you repeat for every patch in this
series. It distracts from the actual change you are making. I would
prefer if you send an introductory/summary email and then focus the
commit message on the actual change you are making.

Regards

Marcel


