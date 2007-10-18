Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXJRLUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXJRLUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXJRLUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:20:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2636 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbXJRLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ut3nlp4/XmcO1nyef1Hb6mM6AvnXYqrdaAqmDAqxH0Hhzk+7gDGBW2QhEUZouLEUgUiWo+Es5S/aFPRj37rK71LTB/2nqS3SmPSMsOabpRaw3hTTHzzrFSUmjMPajESgmelOJ0DuDA219KEhVLdQIwzwPIr5lJm7s8VRz6AvMBY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Thu, 18 Oct 2007 12:19:34 +0100
User-Agent: KMail/1.9.1
Cc: Gabriel C <nix.or.die@googlemail.com>, Hannes Reinecke <hare@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com> <471370C4.8000803@googlemail.com>
In-Reply-To: <471370C4.8000803@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710181219.34951.vda.linux@googlemail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, James,

On Monday 15 October 2007 14:53, Gabriel C wrote:
> >> Compile tested and applies cleanly to 2.6.23.
> >> I don't have this hardware anymore and cannot run test these patches.
> > 
> > I can test these patches on an aic7892 controller later on today if you want.
> 
> Works fine for me tested on :
> 
> 03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m [9005:008f] (rev 02)

I hope this is enough for these patches to be accepted.

If it is not, please let me know what do I need to do more.
--
vda
