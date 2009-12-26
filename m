Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZLZEmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZLZEmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 23:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZLZEmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 23:42:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1431 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbZLZEmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 23:42:45 -0500
Subject: Re: [PATCH] thinkpad_acpi.c: Remove #define TPACPI_<level>s for
 printks
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091226042017.GA14921@khazad-dum.debian.net>
References: <1261797801.2568.69.camel@Joe-Laptop.home>
	 <20091226042017.GA14921@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 20:42:43 -0800
Message-ID: <1261802563.2568.75.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-26 at 02:20 -0200, Henrique de Moraes Holschuh wrote:
> Why would I want a parameter macro instead of a straightforward bunch of
> #defines ?

To make grep a bit easier.

> It is not like the #defines are harder to understand than this
> pr_fmt thing.

Nope, not particularly difficult, but less standard.

> I don't want the pr_foo() siliness in code I maintain.

Your choice.

cheers,

