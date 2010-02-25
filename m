Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab0BYBnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:43:35 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:18273 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab0BYBne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q9a4UEfTWjA0QI3rs+OMIfXW9omKBBzgK862n/5dpbsXlBrPkFqy7gwMhZOhu5n17g
         z4oZzAe5DO+F2SILUx9ezwWeTMvaj7N1BR8UpP1uw4sqb/u45rmlolhTPy2BtIEgyEJO
         168YQ3Mwp23kEkb1QCMDpKcIITyF1AtJ+eFj4=
MIME-Version: 1.0
In-Reply-To: <1267002770.3903.4.camel@jlt3.sipsolutions.net>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
	 <1266679687.17363.1.camel@jlt3.sipsolutions.net>
	 <20100220154049.GM3000@hack>
	 <1266680582.17363.7.camel@jlt3.sipsolutions.net>
	 <1266979753.23523.1670.camel@pasglop>
	 <1266996757.3903.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002232334p219f4ebem6006172153e7a3f1@mail.gmail.com>
	 <1267002770.3903.4.camel@jlt3.sipsolutions.net>
Date: Thu, 25 Feb 2010 09:43:34 +0800
Message-ID: <2375c9f91002241743g304996dfn7f65dab37e7bd6d6@mail.gmail.com>
Subject: Re: [PATCH] windfarm: init sysfs attributes
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 5:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Btw, request_firmware also needs annotation.
>

Oh, mind to send a patch for it? ;)
