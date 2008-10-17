Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYJQDOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYJQDOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYJQDO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:14:29 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:60249 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYJQDO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UKHQEFQCLtXhrNHlGNlZ20rCeVocqmZ/WX1oXIdahixXfJBIei/LPAcxq9/2+6MdWW
         kbUqBqwH2Bhh8whfbRFeoLFyvGpMnOWnCNKDtpzBEtKGqE+DlNyBG47HWZWFIrYnoReP
         DE0zvh+Sd0uuWPJNObhlhV58UXmXGIZTyZaHc=
Message-ID: <aec7e5c30810162014w33fe08f2ta2b05cb187770e3a@mail.gmail.com>
Date: Fri, 17 Oct 2008 12:14:26 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Piot Skamruk" <piotr.skamruk@gmail.com>,
       openwrt-devel@lists.openwrt.org
In-Reply-To: <200807202146.12759.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807202146.12759.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 4:46 AM, Michael Buesch <mb@bu3sch.de> wrote:
> This adds a driver that lets you drive an SPI bus over
> generic GPIO pins.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Very useful. Fits my shiny new GPIO implementation for SuperH like a glove.

Michael, as you know, I have some SuperH board code that makes use of
this driver. Are there any outstanding issues with this driver that I
can help resolving?

Andrew, is this driver still in -mm? Any chance of getting it included
in 2.6.28?

Cheers,

/ magnus
