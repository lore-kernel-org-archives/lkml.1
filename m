Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZJAGuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZJAGuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZJAGuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:50:03 -0400
Received: from poutre.nerim.net ([62.4.16.124]:57775 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZJAGuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:50:01 -0400
Date: Thu, 1 Oct 2009 08:50:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Thomas Backlund <tmb@mandriva.org>, Luca Tettamanti <kronos.it@gmail.com>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       astarikovskiy@suse.de
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
Message-ID: <20091001085002.1dbc7eee@hyperion.delvare>
In-Reply-To: <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	<51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	<20090928131700.GA19243@nb-core2.darkstar.lan>
	<51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>
	<51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>
	<68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>
	<51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
	<4AC21E7B.70000@mandriva.org>
	<51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 17:38:21 -0600, Robert Hancock wrote:
> On Tue, Sep 29, 2009 at 8:49 AM, Thomas Backlund <tmb@mandriva.org> wrote:
> > Try this one:
> > http://marc.info/?l=linux-kernel&m=125421276407283&w=2
> 
> With that patch it's lasted almost a day with no timeouts, previously
> I was getting about one every hour. Has that patch been submitted?

Do you mean you're still getting timeouts but they are less frequent,
or you did not get any timeout at all so far?

-- 
Jean Delvare
