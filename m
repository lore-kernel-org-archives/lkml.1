Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbZFCMW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbZFCMW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZFCMWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:22:21 -0400
Received: from mail-bw0-f165.google.com ([209.85.218.165]:59857 "EHLO
	mail-bw0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZFCMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:22:20 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 08:22:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k4sstAJtLbYRd6rIkoMv7NqYXwHrApBbF42eeoIpkPRyxtlMoySvkecA+5UkPxvVw8
         VUca7aRrFLrQGE9hiIeR8wcxNcE1VIz2rks+s/eNkaTyt4DPon+aBZFJbvDph14XxtcC
         kdqx1PCe98bpckNFVeM+BthHf3e3At713vEcg=
MIME-Version: 1.0
In-Reply-To: <cone.1244020249.943312.16292.1000@arca>
References: <cone.1244020249.943312.16292.1000@arca>
Date: Wed, 3 Jun 2009 14:14:52 +0200
Message-ID: <9ea470500906030514q1f52be64x2ff73a3d27ac62fa@mail.gmail.com>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 3, 2009 at 11:10 AM, Peter Feuerer <peter@piie.net> wrote:
> Hi Len,
>
> please include following driver.
>
> thanks and best regards,
> --peter
>
>
> Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
> the temperature sensor and to control the fan.
>
> Signed-off-by: Peter Feuerer <peter@piie.net>
> Reviewed-by: Borislav Petkov <petkovbb@gmail.com>
> Tested-by: Borislav Petkov <petkovbb@gmail.com>

By the way, your patch is line-wrapped and it won't apply here. See
<Documentation/email-clients.txt> for more info.

-- 
Regards/Gruss,
Boris
