Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZKES5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZKES5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZKES5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:57:08 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49984 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbZKES5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TzZCVZMpFWJQ2MQ6KlzD2+yRdFqX9XG99yRajx0qQp3bsthcK8UgSO1pCgm8MoBt9n
         vWj12l+wRuQ03SIYA5EKGhQO1dwL6y5UVieVf7/VIUtppeSv+xfxQcnjxfjpXU3KkAwr
         Lnh2qVNIdXacMa6ZI4gkppSctZsTHUIPAL0yA=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 24/41] rt2800usb: convert to use struct rt2800_ops methods
Date: Thu, 5 Nov 2009 19:57:09 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173453.28463.94062.sendpatchset@localhost.localdomain> <200911051953.47346.IvDoorn@gmail.com>
In-Reply-To: <200911051953.47346.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051957.09817.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009, Ivo van Doorn wrote:
> On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] rt2800usb: convert to use struct rt2800_ops methods
> > 
> > Add chipset registers access abstraction layer and prepare for later
> > code unification.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 

See comment on patch [23/41]
