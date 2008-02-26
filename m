Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbYBZQMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbYBZQMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762044AbYBZQMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:12:21 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:5585 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760475AbYBZQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jMyhJD7wnwjq47M9hAkQDHpszy++wRqhIm2ZYv1vhDDKaLBmKjOkJMcxCqaxKS1DrYX312ffbO7bUl3zEGMGKOKSKLepVS2wNJNrOe+Ltu2E+caZ+OwugZvTVOEmnCrozNt2MzNiDhuGYLbIXnBn/A+Rb6d8efZxHYmsvFb6vw4=
Message-ID: <97a0a9ac0802260812i6ea53bdfs3b6368649156ac77@mail.gmail.com>
Date: Tue, 26 Feb 2008 09:12:17 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080226143744.GA24332@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802191141.26952.mb@bu3sch.de>
	 <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com>
	 <200802201544.05192.mb@bu3sch.de>
	 <20080220193709.GD21139@uranus.ravnborg.org>
	 <20080226143744.GA24332@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben

On Tue, Feb 26, 2008 at 7:37 AM, Ben Dooks <ben-linux@fluff.org> wrote:

>  I build all of my ARM kernels on an x86 box, it is much faster
>  and I don't have to ensure I have a read/write capable filesystem
>  for any of my ARM boards.

The patch has been merged into Andrew's -mm tree.

http://www.mail-archive.com/mm-commits@vger.kernel.org/msg35079.html

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
