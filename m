Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbXDKSdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbXDKSdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXDKSdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:33:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:36100 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbXDKSdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:33:38 -0400
From: Danny Kukawka <dkukawka@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
Date: Wed, 11 Apr 2007 20:32:11 +0200
User-Agent: KMail/1.9.6
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net, corentincj@iksaif.net,
       sziwan@users.sourceforge.net
References: <22473653910004885@karneval.cz> <461CE6AA.6050806@gmail.com> <200704112018.31026.dkukawka@suse.de>
In-Reply-To: <200704112018.31026.dkukawka@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200704112032.11772.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 11. April 2007, Danny Kukawka wrote:
> Jiri Slaby wrote:
> > Corentin CHARY napsal(a):
> >> Le Wednesday 11 April 2007 11:33:48 Jiri Slaby, vous avez écrit :
> >>> asus_acpi, support F2JE model
> >> Just use the new asus-laptop driver =)
> >> (see acpi4asus-0.40)
> > 
> > code seems good, but this is not so good:
> > #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
> > #warning "This module does not support 2.6.20 yet, wait for a new release
> > #=)" endif
> >
> > When do you plan to support latest kernels and merge it to mainline?
> 
> This patch fixes acpi4asus-0.40 for me at least with 2.6.20 on a ASUS R1F.

Btw. looks as if a new version of the driver (v0.41) is already in the mm-tree.

Danny
