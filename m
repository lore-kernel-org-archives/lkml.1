Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbXEWElm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbXEWElm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXEWEld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:41:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:45949 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbXEWElc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CdlSZWiNATb6BTATMt7jKrIYm+AwimdWTPOUy0FkwfXsGAipcqpYZ1CKrp8xrTjE4H+6TqAGuFt68K7IWKFkrXxJ5UtqUW450nLF0ZFSxdwvrPjZ1rb2GZ6zlsbTMWHs9YLvtbFGQ8slWUzyJBxE/Y46MMIapBzB3iJNVY1mI0c=
Message-ID: <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com>
Date: Tue, 22 May 2007 21:41:30 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Cc: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070523041958.GA15952@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519165738.GK11115@waste.org>
	 <20070519204504.GA24704@khazad-dum.debian.net>
	 <20070519223843.GN11115@waste.org>
	 <20070520035259.GA13224@khazad-dum.debian.net>
	 <20070521222339.GF11115@waste.org>
	 <20070521230349.GA645@khazad-dum.debian.net>
	 <20070522224515.GW11115@waste.org>
	 <20070523001943.GA3743@khazad-dum.debian.net>
	 <20070523014825.GX11115@waste.org>
	 <20070523041958.GA15952@khazad-dum.debian.net>
X-Google-Sender-Auth: 619cb07f90e965fd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > I shouldn't have to upgrade my BIOS to work with a new kernel any more
> > than I should have to upgrade my browser.
>
> We don't agree there, as you are not talking about a stable kernel series.

Ah, so you're planning on submitting these patches for 2.7 then? 2.6
is perpetually stable. Matt is quite correct; feel free to ask for
clarifications from Linus et al if you need guidance.
