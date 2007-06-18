Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbXFRRNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbXFRRNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXFRRNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:13:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:32748 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbXFRRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RtOEYGAgjt97ZsyWT3aCk1t+M81sg4AS3XP9dXqb/CKx+X3B3h5vhyFGTOOE5vP9eiGk8qkYLD3LOgu0ROcrcdRSCXncVNe2ekmMeKrfO/O0wdZCN4xxRFy6ZES7z1cTOwDrW0GuTEllIfEuZfs2iWk88x7ktC6nNoYTTuAkMwc=
Message-ID: <75b66ecd0706181013g4f2537d0kab676986f0323483@mail.gmail.com>
Date: Mon, 18 Jun 2007 13:13:41 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Stable identification of identical USB hardware
In-Reply-To: <20070618170027.GA11233@elmicha>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <157636.91774.qm@web51404.mail.re2.yahoo.com>
	 <20070618170027.GA11233@elmicha>
X-Google-Sender-Auth: e4d1aff7feb46594
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Michael Mauch <michael.mauch@gmx.de> wrote:
> > If I have to cardbus sockets, how do I get from what I know ("the card
> > is in socket 0") to "I have to talk to ttyUSB2 to talk to the card"? I
> > suspect I have to follow the thread from /sys/bus/pci to
> > /sys/bus/usb/devices, but how exactly?
>
> You should be able to distinguish the devices with udev. Have a look at
> http://www.reactivated.net/writing_udev_rules.html
>

Isn't this something that the distro should do for you?  It's insane
to expect users to write udev rules for such basic functionality...

Lee
