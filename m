Return-Path: <linux-kernel-owner+w=401wt.eu-S934364AbXK3CTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbXK3CTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbXK3CSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:18:44 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:42739 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160AbXK3CSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:18:41 -0500
Message-ID: <474F72E3.4040608@keyaccess.nl>
Date: Fri, 30 Nov 2007 03:18:11 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Zhao Yakui <yakui.zhao@intel.com>,
       Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: pnpacpi : exceeded the max number of IO resources
References: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>
In-Reply-To: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-11-07 10:11, Dave Young wrote:

> The pnpacpi rsparser.c report warnings of:
> exceeded the max number of IO resources: 24
> 
> dmesg|grep exceeded|wc
>     66     594    3564

Heavens... (added CCs of people who just upped it from 8 -- I suppose the 
problem is not new then?)

Rene.

