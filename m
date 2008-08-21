Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYHUOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYHUOT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYHUOTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:19:45 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:23344 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYHUOTo (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VwDLmavbQlgWl3R73UnNmtQ8AE2rm46KCvxpjOocSx9gFzCYT/8vr4OpxPKjjRC344
         ViFNsCFozZRVWqQAn2r897LIAcQbrnrbeU2H7L0roLoo4THbFVuBqus0wgwFfx6ruxDf
         EBWcPOdaEP5mAu/iYhWjW+mlU6IetaZBka2nE=
Message-ID: <6934efce0808210719s6458dc77w2c0755a4bf90bf8a@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:19:43 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Jared Hulbert" <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <20080821083916.GF5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821083916.GF5706@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, I'm not sure it's a good idea to name this new filesystem AXFS.
> People are almost certainly going to confuse it with XFS despite
> the filesystems being aimed at diammetrically opposed ends of the
> storage spectrum. ;)

In principle I think you are right.  AXFS and XFS are similar names
and it could lead to confusion.  I think XFS should change its name to
prevent confusion.  I think by 2 years AXFS will be used in orders of
magnitude more machines anyway.  ;)

About opposite end of the spectrum...  Carsten just said AXFS might be
nice for s390, so I'm not sure how true that is.

I'm kind of attached to the name now.
