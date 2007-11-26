Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXKZRda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXKZRda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXKZRdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:33:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:16937 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXKZRdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:33:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XE5NVVo0jhGlzW+vaWHPoRJZw56HuxfhLvceDtBkfo4fHZReSrYSKiYtWrrVbRlKOSUV84EsZDoKMz5PtCZi6CaHEtO9RwgRTKSI+OS6Y20cAb3HSaNvxPnExCYQe/ooXxXE1sCCx+ldQfngmxmb9xlKMsNpgN96E0JLAitZqUg=
Message-ID: <1ba2fa240711260933x5ed85123vc33d7d3a5e1bd866@mail.gmail.com>
Date: Mon, 26 Nov 2007 19:33:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 2/2] iwlwifi: add power management support -v2
Cc: "=?ISO-8859-1?Q?Miguel_Bot=F3n?=" <mboton.lkml@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       yi.zhu@intel.com
In-Reply-To: <1196097270.23210.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200711170006.49654.mboton.lkml@gmail.com>
	 <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
	 <200711261718.14711.mboton@gmail.com>
	 <1ba2fa240711260911i705350f3hefeddc7a09f76d1a@mail.gmail.com>
	 <1196097270.23210.0.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> At some point everyone needs to standardize on power levels so that
> userland has a hope of mapping the right state to the right power level
> in the driver.  Otherwise, we get into a situation where broadcom power
> levels don't map the same way iwl powerlevels do, and then we can't ever
> do the right thing.
>
Agree, these are just misleading  names IMHO.

> dan
>
> > Tomas
>
> >
> > > --
> > >        Miguel Botón
> > >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
