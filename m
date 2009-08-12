Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZHLVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZHLVps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZHLVpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:45:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZHLVpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:45:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: acpi_ex_system_memory_space_handler oops
Date: Wed, 12 Aug 2009 23:46:33 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090812201034.GA2983@localdomain.by>
In-Reply-To: <20090812201034.GA2983@localdomain.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122346.33626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Sergey Senozhatsky wrote:
> Hello,
> 
> Kernel oopses on early boot stages (boots normally with boot_delay=10).
> 
> rc5-git8
> eip: acpi_ex_system_memory_space_handler+0x75/0x22f

Do I assume correctly that it didn't happen before?

Rafael
