Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbZCZRCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbZCZRCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbZCZRC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:02:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:15959 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZCZRC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AZRyr24fwX+W9FBOW2A8Zw0z+qua71MXRpJwnt9sRkLNJXCP8zZuqJ5FIMkYv5LORb
         29OcJRi6xrifzBp3SWA4xhSB+bYyjwm9hLqDh32gghOMqwrFF27jZe/VT2+1g630qNi8
         VEmtwXJFFP6x+XW0J4CxGO44mr6iTUXHKncnA=
MIME-Version: 1.0
In-Reply-To: <20090326.204416.65192110.anemo@mba.ocn.ne.jp>
References: <e9c3a7c20903161339o31470datdb2e82649a52bcf0@mail.gmail.com>
	 <20090325.184215.229418774.nemoto@toshiba-tops.co.jp>
	 <e9c3a7c20903250927iea1a4b1h1041deee251e4e5f@mail.gmail.com>
	 <20090326.204416.65192110.anemo@mba.ocn.ne.jp>
Date: Thu, 26 Mar 2009 10:02:25 -0700
X-Google-Sender-Auth: d52a405a0a1148be
Message-ID: <e9c3a7c20903261002o218b06avbb6def76ba91535@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 4:44 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> Thanks.  And now the patch can be applied using git-am as is.
> Should I rebase and send again?

No need, it's now applied.

Thanks,
Dan
