Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0BASBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:01:41 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:60036 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0BASBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qducSP4eFE0igVtN0EF2rU7sGMaE3pIRPb4WyJCGYc3N+3NIJzQmul8PqF31rpjNwm
         PVhmhE7HhUFUp6gy6J7XddvkjJeftG+LjvVgqKTR9c9JiYe0K+In5MZxZ2su5QOFWZ9a
         sUr6r8h7T2IwpKSgLfc7+HCdGD++UMnqaUlX8=
MIME-Version: 1.0
In-Reply-To: <1264972854.3597.17.camel@johannes.local>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com> 
	<4B65F024.3080505@gmail.com> <1264972854.3597.17.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Feb 2010 10:01:17 -0800
Message-ID: <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com>
Subject: Re: Linux wireless GSoC 2010 project ideas
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Witold Sowa <witold.sowa@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 1:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2010-01-31 at 22:03 +0100, Witold Sowa wrote:
>
>> Some time ago johill asked me if I would be interested in hacking on
>> adding WPS support to NetworkManager. Well, I would but I don't know
>> when I'll find some time for that. I don't know how much of work would
>> it require, but it possibly could be a topic of one of GSoC 2010
>> projects. I have no idea know if anybody would be willing to be a mentor
>> for such a project.
>
> Sounds like a good project to me, but I don't think I'd be a good mentor
> for since I'm not familiar with the NM codebase at all. As for how much
> work it would require, I think the basic client-side functionality could
> possibly be "too simple" for you, WPS has a lot of additional
> functionality (e.g. WPS support for the AP side).

In case it helps, I believe all that would be required is the dbus
stuff, there are sample GUI examples of this already provided through
the wpa_supplicant wpa_gui.

  Luis
