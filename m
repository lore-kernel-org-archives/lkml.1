Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZJAPC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZJAPC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZJAPC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:02:27 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:52682 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZJAPC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:02:26 -0400
Message-ID: <4AC4C481.1050302@mandriva.org>
Date: Thu, 01 Oct 2009 18:02:25 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Thomas Backlund <tmb@mandriva.org>, Luca Tettamanti <kronos.it@gmail.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "astarikovskiy@suse.de" <astarikovskiy@suse.de>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
References: <20090923191240.GA15198@dreamland.darkstar.lan>	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>	 <20090928131700.GA19243@nb-core2.darkstar.lan>	 <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>	 <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>	 <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>	 <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>	 <4AC21E7B.70000@mandriva.org> <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com>
In-Reply-To: <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On Tue, Sep 29, 2009 at 8:49 AM, Thomas Backlund <tmb@mandriva.org> wrote:
>> Try this one:
>> http://marc.info/?l=linux-kernel&m=125421276407283&w=2
> 
> With that patch it's lasted almost a day with no timeouts, previously
> I was getting about one every hour. Has that patch been submitted?
> .

I assume it will come through the acpi tree as it's a fix to an (other) 
acpi ec regression...

--
Thomas
