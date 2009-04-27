Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbZD0WDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbZD0WDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbZD0WCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:02:50 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33515 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575AbZD0WCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0904271752090.18696-100000@netrider.rowland.org>
References: <ac3eb2510904271407l7a480744s36d60025948aebd8@mail.gmail.com> 
	<Pine.LNX.4.44L0.0904271752090.18696-100000@netrider.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 28 Apr 2009 00:02:32 +0200
Message-ID: <ac3eb2510904271502k1c25ed6co31bcb3c22a28fa7c@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 23:54, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 27 Apr 2009, Kay Sievers wrote:

>> There is in most cases no point in keeping outdated spec files or
>> debian directories in upstream source packages. The best when updating
>> a package, is to start with the one that is in the source rpm of the
>> distro one uses.
>
> But what if the distro doesn't ship that package at all?  Then it's
> good to at least have a starting point that you can adapt to your own
> needs.  (Although I don't know of any major distributions that doesn't
> include usbutils...)

Maybe add a link to a distro spec file in the README? So this gets
updated automatically by the people who do the packaging? Like this:
  http://cvs.fedora.redhat.com/viewvc/devel/usbutils/usbutils.spec?revision=HEAD

Kay
