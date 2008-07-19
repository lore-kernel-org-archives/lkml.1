Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYGSMbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYGSMbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYGSMar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:30:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:10464 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbYGSMao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bJ4f4mtiOeqz3isVTTZfpPOntU9O6F/fiqKTLThZakmEvD3BZJ2ZcxbWfGlK+qcUt5
         +9l4SAIrvxGLJn34ergjGc8cm5UP6wWdeJcNALs05r4vFU6BsHKmnY80wehj0lu3G6bV
         n44Pe66etk5DIlgEDLOHuvE+TcufHleRffLF8=
Message-ID: <3d8471ca0807190530k6bd91b1ao8995cbad1f4e3b93@mail.gmail.com>
Date: Sat, 19 Jul 2008 14:30:42 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Alan Jenkins" <aj504@cs.york.ac.uk>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <50b515e4-6cd1-4b18-93e3-ecfab5925f02@34g2000hsf.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aPfh5-7kW-5@gated-at.bofh.it> <aPfhe-7kW-31@gated-at.bofh.it>
	 <aQUio-2qG-25@gated-at.bofh.it> <aR0nM-6kd-15@gated-at.bofh.it>
	 <aR3vi-3MV-15@gated-at.bofh.it> <aR4Ur-6c7-27@gated-at.bofh.it>
	 <aReqy-5vm-1@gated-at.bofh.it>
	 <50b515e4-6cd1-4b18-93e3-ecfab5925f02@34g2000hsf.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 2:22 PM, Alan Jenkins <aj504@cs.york.ac.uk> wrote:
> I'm not sure what could happen if it's broken somehow :-).  If you
> have ACPI hotkeys (i.e. running acpi_listen shows events when you
> press hotkeys), please check they still work.

The symptoms for me (still present in 2.6.26) were that ACPI hotkeys
were very laggy, and your patches fix that completely. Nice work :-)

BTW, I have an Asus V6VA.

Thanks.

-- 
Guillaume
