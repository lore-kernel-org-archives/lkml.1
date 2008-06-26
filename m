Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYFZGrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYFZGrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYFZGrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:47:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:13118 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYFZGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WzuPTRq0f+S2Z/rGDRHpuUtb+CquZwzhhlwqjZaYpsU1t3S5iEirfW3/AjhSwIHgsO
         Ah9HR5aRfEnryo36Bw4bl9X0lvPgce5Oyf4T2joU8pWUz6CBNOSeAqImqwz+slXKifH8
         t1oYUmBIzFwPIMXHtgc+7Pmzao3mdLJb0IjYM=
Message-ID: <e2e108260806252347m7a6b114by5b5100a86ce35a55@mail.gmail.com>
Date: Thu, 26 Jun 2008 08:47:34 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Mayank Sharma" <mayanks@sirf.com>
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 1:48 PM, Mayank Sharma <mayanks@sirf.com> wrote:
> I noticed a bug with respect to time drifting after multiple sleep/wakeup sequence.

I suggest that you CC at least one ARM-specific mailing list, and also
that you specify which kernel version the original behavior was
observed on. Were you working with a vanilla Linux kernel or a patched
one ?

Bart.
