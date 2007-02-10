Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXBJRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXBJRCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXBJRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:02:18 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:55841 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751252AbXBJRCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:02:18 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Date: Sat, 10 Feb 2007 19:02:10 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <200702071418.51058.lenb@kernel.org> <200702101752.14797.ismail@pardus.org.tr> <20070210163927.GA489@khazad-dum.debian.net>
In-Reply-To: <20070210163927.GA489@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702101902.10776.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 18:39:27 Henrique de Moraes Holschuh wrote:
> On Sat, 10 Feb 2007, Ismail Dönmez wrote:
> > Hmmf looks like a userspace bug, but it certainly did work before ACPI
> > update.
>
> Well, I don't know if this is the case here, but after reading the userland
> code that people use on most applets to read /proc/acpi/ibm, I was upset
> and disgusted for days.
>
> Some userland code *deserves* to be broken with extreme prejudice.

Must be because there is no unified way to read this info ;) Userspace is 
honestly not guilty here.

Regards,
ismail

