Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYBFWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYBFWU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbYBFWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:20:15 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:53187 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbYBFWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=G/q/tUuGpPT//vgWGAymhZuj9RbmqSTBJKOMx8RLG1g6U6y3l6XzAFalMJQAyaAQz05eq3SmjLc4FeyvDZ+w10KLa9X0Xs8Jv2EwWaA5bvAFrSnq5kVYnrgMUPFwYl+gY0FEK8H5RQVMrtMl39zQf0i+sPp2XjBewhSG1P3sE7I=
Message-ID: <31e679430802061420m113f7fa9tdfe8fd24929ed4c6@mail.gmail.com>
Date: Wed, 6 Feb 2008 17:20:09 -0500
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: T61P sound issue
Cc: "Theodore Tso" <tytso@mit.edu>, tiwai@suse.de,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802061455110.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
	 <20080204194038.d8851b8d.akpm@linux-foundation.org>
	 <20080205113633.GI27738@hjernemadsen.org>
	 <20080205102219.83fe459d.akpm@linux-foundation.org>
	 <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com>
	 <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz>
	 <20080206022517.GB27119@mit.edu>
	 <Pine.LNX.4.64.0802060909420.30873@twin.jikos.cz>
	 <20080206135306.GI27119@mit.edu>
	 <Pine.LNX.4.64.0802061455110.30873@twin.jikos.cz>
X-Google-Sender-Auth: 5088b25aad3b5208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Feb 6, 2008 8:56 AM, Jiri Kosina <jikos@jikos.cz> wrote:
> On Wed, 6 Feb 2008, Theodore Tso wrote:
>
> > > I have also seen sound working flawlessly on another X61s. Maybe they
> > > changed some chipset revisions on the fly, or whatever.
> > > What does lspci -v show for your soundcard please?
> > Attached please find my lspci -v and dmidecode information.
>
> Thanks. As I have already written elsewhere in this thread, the problem
> went away after I updated the BIOS to the latest version. So it was Lenovo
> who was to blame, and I was just unlucky enough to hit the series with
> broken BIOS.
>

BIOS upgraded, now the sound works on consoles (beeps) but not even
alsaplayer can play sounds.

I'll keep trying.

In any case, I have other issues: Serial port is really laggy (on Dock
of course), even if I use a usb-serial converter, still laggy (laptop
or dock).
USB is taking ages to enumerate.

If anyone has any clue about these... please shoot me :-p

> Thanks,
>
> --
> Jiri Kosina
>



-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
