Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbYCBWCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbYCBWCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYCBWCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:02:33 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:4181 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYCBWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fNrNc4KqLw/NB+yoidjCQewf5/WGclgBEpBBPVpFXwmpXXS+HqlIj0gtsflmEY1wR09rT47qecqqmfdG7pIwqkBlDF4tGWi1KMNvntoa0iNFnMH5CFs3UT/nL5NAsiHOISNh/aJR+sA/Jb2OXHUf/HhdmjgMobI3C0fX+yCeAA8=
Message-ID: <524f69650803021402q93534c4w5acaa01fe1d1dd6f@mail.gmail.com>
Date: Sun, 2 Mar 2008 16:02:31 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Martin Langhoff" <martin.langhoff@gmail.com>
Subject: Re: kernel.org git tree corrupt?
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, git@vger.kernel.org
In-Reply-To: <46a038f90803021340uf1c9c6te5501d9fb0565f19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650803020749o469f2e48l125a55267b0b5d13@mail.gmail.com>
	 <alpine.LFD.1.00.0803021302070.17889@woody.linux-foundation.org>
	 <46a038f90803021340uf1c9c6te5501d9fb0565f19@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 3:40 PM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> On Mon, Mar 3, 2008 at 10:16 AM, Linus Torvalds
>  <torvalds@linux-foundation.org> wrote:
>  >  In that case, your "origin" simply isn't updated, but points somewhere
>  >  long back in history. I can only assume that cogito has done something
>  >  wrong, like not been able to handle packed refs or something, and you have
>  >  an updated tree but "origin" pointing to way back in the history.
>
>  Strange - cogito over git protocol will use git itself to peek at the
>  references. Steve, what is your git version?

This is master.kernel.org so git version is 1.5.4.3

-- 
Thanks,

Steve
