Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZDZW0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZDZW0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 18:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZDZWZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 18:25:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:63923 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZDZWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 18:25:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jYgPuVD/qpDiNieVip5drc6iV6/Eh1/YBoHyRHTCyqRXLdhejJt225HyK/v6wnuvhK
         1cDHlrPR2FZIUZ3T8g1cm2T4rU737BTvdJKqCbwExIFI0SPdBienXVcOa/13Bm7Ytv2S
         Ev88Zzj38sagP3aFK5yLIUv+tWO4KF0QTcsgI=
Message-ID: <49F4DFA9.6040805@gmail.com>
Date: Mon, 27 Apr 2009 07:26:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fix suspend/resume for ATA SEMB devices
References: <20090426143836.GA3643@liondog.tnic>
In-Reply-To: <20090426143836.GA3643@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> due to a class mismatch in ata_dev_revalidate(). Fix it by adding the
> ATA_DEV_SEMB device class to the check.
> 
> CC: Tejun Heo <htejun@gmail.com>
> CC: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
