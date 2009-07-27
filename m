Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZG0Liq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZG0Liq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZG0Lip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:38:45 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49672 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZG0Lip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pDg0I3xZbdVjhrNiGieeatVaBnX2hnw1IGz+vn02AcVHvScy53ZFf/uAgLd9Xa6sZV
         1cJBaZif4X182PWIIHAyvkkMFRY9PTqOibFSAgGHg3PDDyh48FUE5OLDyG4QBeFtQFfl
         BzITqWQ5pJwnPtlluB2DZYtEcNHW6fAPnH4sc=
MIME-Version: 1.0
In-Reply-To: <200907271109.33271.philipp.reisner@linbit.com>
References: <20090727173754.6a04e781.sfr@canb.auug.org.au>
	 <200907271109.33271.philipp.reisner@linbit.com>
Date: Mon, 27 Jul 2009 15:38:44 +0400
Message-ID: <a4423d670907270438n3e8f07caoa45124b1bd7b2386@mail.gmail.com>
Subject: Re: linux-next: drbd tree build failure
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more issue

drivers/block/drbd/drbd_main.c: In function 'drbd_buildtag':
drivers/block/drbd/drbd_main.c:3738: error: dereferencing pointer to
incomplete type
