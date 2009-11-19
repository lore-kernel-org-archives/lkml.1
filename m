Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZKSOXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZKSOXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZKSOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:23:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:63303 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZKSOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=woqjvynYqAm5mZ4EkqZTRf1dgs5gtG3BnwAkDClB/bu9iWbYvZyr6j/Z5EFIN+5VMX
         QUAg5zXFhMJ7VmmCia/U5nqWomw7LwhuQb35Cz9kKhVwouLwWUmIAjIsxBCVAjTwAUgh
         +/3A0toatwLwIqAbngibjAJtzhSSpjW83hh+E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 15:22:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911182056.16517.bzolnier@gmail.com> <20091119140259.2fee86e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119140259.2fee86e2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191522.26761.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 15:02:59 Alan Cox wrote:
> > BTW we can immediately reclaim 300 LOC by simply merging drivers back..
> 
> LoC - lines of comments ? (at least half of them).

lol, I _only_ counted whole functions + their documentation to come up with
this fairly _conservative_ number... 

-- 
Bartlomiej Zolnierkiewicz
