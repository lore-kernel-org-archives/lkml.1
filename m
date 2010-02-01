Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0BAVcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:32:01 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53543 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab0BAVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:31:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vFu8IxI7OG2fiFLKQjYjAAn9F1m6GNJsy34WbF00QEB68MTBe9UOQaA2z5btR4+s+o
         TKdNwbEjAQUTPDZ5Pag2fUqWLP5ZyLk0zGQdgzCQiEiiCVdWIg/LkOOOcZ7JQ8eHnddJ
         AyUVwZQKcTgjffIvWivJwWuj3qOjv5HQXgfck=
Subject: Re: Linux wireless GSoC 2010 project ideas
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: david@lang.hm
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Witold Sowa <witold.sowa@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
In-Reply-To: <alpine.DEB.2.00.1002011216040.7748@asgard.lang.hm>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
	 <4B65F024.3080505@gmail.com> <1264972854.3597.17.camel@johannes.local>
	 <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com>
	 <1265055284.26421.16.camel@maxim-laptop>
	 <alpine.DEB.2.00.1002011216040.7748@asgard.lang.hm>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 23:31:53 +0200
Message-ID: <1265059913.26165.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 12:17 -0800, david@lang.hm wrote: 
> On Mon, 1 Feb 2010, Maxim Levitsky wrote:
> 
> > On Mon, 2010-02-01 at 10:01 -0800, Luis R. Rodriguez wrote:
> >> On Sun, Jan 31, 2010 at 1:20 PM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >>> On Sun, 2010-01-31 at 22:03 +0100, Witold Sowa wrote:
> >>>
> >>>> Some time ago johill asked me if I would be interested in hacking on
> >>>> adding WPS support to NetworkManager. Well, I would but I don't know
> >>>> when I'll find some time for that. I don't know how much of work would
> >>>> it require, but it possibly could be a topic of one of GSoC 2010
> >>>> projects. I have no idea know if anybody would be willing to be a mentor
> >>>> for such a project.
> >>>
> >>> Sounds like a good project to me, but I don't think I'd be a good mentor
> >>> for since I'm not familiar with the NM codebase at all. As for how much
> >>> work it would require, I think the basic client-side functionality could
> >>> possibly be "too simple" for you, WPS has a lot of additional
> >>> functionality (e.g. WPS support for the AP side).
> >>
> >> In case it helps, I believe all that would be required is the dbus
> >> stuff, there are sample GUI examples of this already provided through
> >> the wpa_supplicant wpa_gui.
> >
> > Here are couple of ideas (I don't think I will enter the program
> > though):
> >
> > 1 - Make Ad-Hoc WPA networks work (with NM). This would involve changes
> > in kernel, but I don't think will involve changes in hardware drivers.
> >
> > 2 - Allow a wireless card to associate to several APs at once (if they
> > share the frequency).
> > Implement this at least for ath5/9k. Madwifi had that feature. Maybe
> > ath9k has. If it has that feature, test it.
> > Implement proper GUI support in NM for that.
> 
> why would you want to do this?
To create a wireless router.
However, yes, I probably meant an access point and wireless client at
same time.



> 
> > 3 - Create wardriving^Wwireless analysis tool.
> > No, not for wardriving. I mean an application that shows and analyzes
> > nicely the signal strength of nearby APs, and other features of it
> 
> it seems to me that kismet provides exactly this capability, what is it 
> missing?
Didn't use this tool.
Also, like I said, this should be a analysis, and not wardriving/hacking
tool.
And with GUI.



Best regards,
Maxim Levitsky

