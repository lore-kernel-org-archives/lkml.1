Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZLZVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZLZVgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZLZVgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:36:15 -0500
Received: from mail.vyatta.com ([76.74.103.46]:35076 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbZLZVgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:36:14 -0500
Date: Sat, 26 Dec 2009 13:36:04 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute 2.6.32 released
Message-ID: <20091226133604.7f85a4e7@nehalam>
In-Reply-To: <8bd0f97a0912261143h48aaaaefw5a83e65120629e75@mail.gmail.com>
References: <20091226105821.52d36ba8@nehalam>
	<8bd0f97a0912261143h48aaaaefw5a83e65120629e75@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Dec 2009 14:43:10 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Sat, Dec 26, 2009 at 13:58, Stephen Hemminger wrote:
> > This version of iproute2 utilities includes the changes necessary to support all the features in
> > 2.6.32, but should be backward compatible with older releases. Lots of bug fixes and little
> > things, the main area of change is around the always problematic 'ip route flush' interface.
> >
> > The tar ball is available at:
> >  http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.31.tar.bz2
> 
> URL and git says 2.6.31, but subject says 2.6.32, so i'm guessing
> subject is the typoe
> -mike

Actually, the url is typo

-- 
