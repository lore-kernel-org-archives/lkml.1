Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZIHTol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZIHTol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZIHTol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:44:41 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:64068 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZIHTok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OiQifvBhrdk9gGXKV4nTpA3G6BGa5NFKx0+ECv/A4N/HBqiUb5VAHV1qhAmM41ZNmB
         jRbnyaFaMwl+vWwhfm5+ezGahOvK/nxDh7aBuFxX9sLKnXxVJtxThudbmaHAOZ03l1O9
         FPfgJMX3lg+FrNs1r81sFAByIK+tE+q9iET5E=
MIME-Version: 1.0
In-Reply-To: <43e72e890909081230h420c2abi125a6fbfc2777250@mail.gmail.com>
References: <43e72e890909081230h420c2abi125a6fbfc2777250@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 12:44:23 -0700
Message-ID: <43e72e890909081244m4083a1bcq30cf1306ce566726@mail.gmail.com>
Subject: Re: 2.6.27 maintenance plans after 2.6.32 is released
To: Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Cc: stable-review@kernel.org, linux-kernel@vger.kernel.org,
       stable-review@linux.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 12:30 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> I was curious if 2.6.27 is planned to be supported after 2.6.32 is
> released, or will that be dropped in favor for 2.6.28 as the last
> supported kernel. How does dropping an old kernel for stable
> maintenance consideration typically work?

Adding the stable-review@linux.kernel.org list now, seems
stable-review@kernel.org is an alias.

  Luis
