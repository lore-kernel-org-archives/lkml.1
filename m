Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZFELAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZFELAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZFELAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:00:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3718 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZFELAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:00:42 -0400
Subject: Re: [PATCH] eeepc-laptop.c: use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: acpi4asus-user@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Corentin Chary <corentincj@iksaif.net>,
       Matthew Garrett <mjg@redhat.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4A28F94A.6040500@tuffmail.co.uk>
References: <1244197103.3631.40.camel@Joe-Laptop.home>
	 <4A28F94A.6040500@tuffmail.co.uk>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 04:00:33 -0700
Message-Id: <1244199633.3631.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 11:54 +0100, Alan Jenkins wrote:
> Is EEEPC_HOTK_FILE used anywhere else?  It would be clearer if you were 
> able to just use "eeepc: " or whatever and remove the definition of 
> EEEPC_HOTK_FILE.

It is used elsewhere and perhaps it'd be better to use KBUILD_MODNAME.

cheers, Joe

