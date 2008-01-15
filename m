Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYAOTAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYAOTAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbYAOTAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:00:16 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:23529 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAOTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:00:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jecP0aYGx1HgbuxTa0Kr+oE73zgkXVhZ3wsKr/dmAxlPj9dbH+zehA2le0oaCiwRLisCzIRSL2PmI6N6nlLWwKpZdufEpri0ezLgRBL2obLfzWalGmMj0JmbFwdBmBGZkl1nA9whHE6etVWycJU11UUTQWoiuikRJ5ebXBESjok=
Message-ID: <df47b87a0801151100qe7c39f1y3296176f343667eb@mail.gmail.com>
Date: Tue, 15 Jan 2008 21:00:13 +0200
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Stephen Hemminger" <stephen.hemminger@vyatta.com>
Subject: Re: sky2 patch in 2.6.24-rc7-git6 breaks POST - commit 84cd2dfb04d23a961c5f537baa243fa54d0987ac
Cc: netdev@vger.kernel.org, jeff@garzik.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080115100947.4ec6cda0@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df47b87a0801150301w6b970decwdd4bd256aa2ca9ac@mail.gmail.com>
	 <20080115100947.4ec6cda0@deepthought>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 8:09 PM, Stephen Hemminger <stephen.hemminger@vyatta.com> wrote:
> On Tue, 15 Jan 2008 13:01:47 +0200
> "Ioan Ionita" <opslynx@gmail.com> wrote:
>

>
> Is Wake On Lan enabled in the BIOS?

I don't have a Wake on Lan option in BIOS, only wake on pci, i assume
it's the same.  It was disabled. I enabled it and the regression
behaved the same way.  Wouldn't POST after shutdown or soft reset.

Regards
