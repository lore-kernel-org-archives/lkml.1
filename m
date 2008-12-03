Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYLCAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYLCAUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYLCAUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:20:35 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:5937 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbYLCAUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=B1H7UfYdf/cuhKiqGBqZ+5k6a368cwaA277VlajuXhknNHHn9+PgyyxQy5bJ6ViZvP
         j8JXHQ6LApmBonq3CaCkqwIXlOq94DHUTRZmcqDJrjHlQFfpPyec8fwJhHbupVRM7/Fg
         aWYhFjdQSc1uPxsKnIMZ/H3arK4wurpYfKjpY=
Message-ID: <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>
Date: Tue, 2 Dec 2008 16:20:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Greg KH" <greg@kroah.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX gracefully
Cc: stable@kernel.org, sfr@canb.auug.org.au, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081203001253.GC14943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-3-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-4-git-send-email-lrodriguez@atheros.com>
	 <20081203001253.GC14943@kroah.com>
X-Google-Sender-Auth: 2a034d07e302a912
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 4:12 PM, Greg KH <greg@kroah.com> wrote:
> I don't see this patch upstream in Linus's tree.  Am I just missing it
> and if so, do you know the git commit id?

Nope sorry, John has yet to send his pending-fixes branch to davem and
so forth, which would contain it AFAICT. Please correct me if I'm
wrong John.

  Luis
