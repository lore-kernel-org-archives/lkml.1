Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYGUT6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYGUT6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYGUT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:57:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:38939 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYGUT5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UiWyOcJzbboT4KR42/R+L+m8TRk/tvC4rsGa/v/zMdrzL3APFg8rdttAChtdQQKqFB
         Y4yB1BKmnuNhoTPPYSw2BO4pzAv6LXVUMlrW8G1EO7RazIPO47x4jKiqcs65KVTgyZ/P
         41nVUnrwG/HCylhyUVKwD8pzJBEeJayvkaUh0=
Message-ID: <5f6f8c5f0807211257j668535eam873275afc2040f73@mail.gmail.com>
Date: Mon, 21 Jul 2008 21:57:51 +0200
From: "Joshua C." <joshuacov@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: ACPI: ACPI_CUSTOM_DSDT_INITRD option
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/21 Ben Collins <ben.collins@canonical.com>:
>
> Could you rebase it on latest git (lots of fuzz)? Other than that, it
> looks good to me. We've been carrying this patch forever, so would be
> nice to have it applied upstream finally.
>
>

I tried the current patch (acpi-dsdt-initrd-v0.9a-2.6.25.patch) with
fedora kernel-2.6.27-0.161.rc0.git6.fc10 which is git6 and it compiled
without any problems. I didn't modify anything on the patch. so it
should be "production" ready in its current state, shouldn't it? Maybe
this time it can make its way upstream.
