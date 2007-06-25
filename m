Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbXFYJx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbXFYJx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXFYJxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:53:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:58268 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbXFYJxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QqZ+pGtDnlB3/XJUpn2sil+hljSUlWRDpsmlNzMzPGCNFJz+k7drV3cckykiV23e0XRdgOPGGS8IknxFZ9hbIs16MraCWYBBeZ4mnfEE/dAiRmOhue7uZqdkx93a1I/QaQ1DnFwlbxSqaKvrptYp11BSIIKlCFW7zxmr7b32IXA=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>
In-Reply-To: <200706231656.39597.eike-kernel@sf-tec.de>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <200706231656.39597.eike-kernel@sf-tec.de>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 10:52:36 +0100
Message-Id: <1182765156.2519.0.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 16:56 +0200, Rolf Eike Beer wrote:
> None of the above keys generated a key event. Neither does "Brightness down", 
> but it still works. "Brightness up" generates an event and works. Kpowersave 
> tells me it can't do brightness switching in software (which works in 
> WinXtraPain).

Do you know how windows does this? Do you have to load a special
system-try thing to make the keys work?

Richard.


