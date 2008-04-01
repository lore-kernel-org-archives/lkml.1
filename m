Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbYDAUGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbYDAUGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbYDAUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:06:12 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:28555 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbYDAUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k2rdc29YBilDPU64vvkyU0NR1eB/Bftt29UWOhjg7NjOL7GuJilCJMqrfd0URmev7zw3Bz3fZXrp7vrX/Dt5Sqe3KTOT2MNVEDmLNcJ3lXMf5y2yWZ3ll11trJKqVYpQtUwGTiW9BukuxhgejCtP4XxfBFBQMqHHNGJmTo022II=
Message-ID: <5d75f4610804011306y55352e73sb5223a294b66f2cf@mail.gmail.com>
Date: Wed, 2 Apr 2008 03:06:07 +0700
From: "BuraphaLinux Server" <buraphalinuxserver@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: New IWL4935 driver for Intel Wireless Cards does not support WPA2 wireless network with PEAP - MSCHAPV2
Cc: "Luca Venturini" <lucventurini@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080401164419.GA3530@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F1F4F4.2080502@gmail.com> <20080401164419.GA3530@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel wireless just doesn't work on linux 2.6.24.4; wait for 2.6.25.x stable.

On 4/1/08, John W. Linville <linville@tuxdriver.com> wrote:
> You probably want to address this to linux-wireless@vger.kernel.org
> instead...
>
> On Tue, Apr 01, 2008 at 10:40:20AM +0200, Luca Venturini wrote:
> > Using Ubuntu Hardy Beta, Linux kernel 2.6.24, AMD64.
> > I have to connect to a campus (University of Verona, Italy; more
> > information maybe available at https://wifi.univr.it sadly in Italian
> only,
> > and I am not sure it is reachable from outside the university) WPA2
> > wireless network. It uses PEAP authentication, Dynamic WEP encryption,
> > second phase: MSCHAPv2.
> > It also requires user login, password, and a CA certificate (available at
> > the web page I linked above).
> > At the same page a wpasupplicant configuration file is also available, so
> > to allow people to connect from linux also.
> > In Ubuntu Gutsy 32 bit (Linux kernel 2.6.22.14 if I am not mistaken) I was
> > able to connect through NetworkManager and precisely using the GNOME
> > nm-applet.
> > However, since I switched to Linux 2.6.24, I have no more been able to
> > connect, whether through NM-applet or from the command line, using
> > wpasupplicant. The wireless functions perfectly, and there has been no
> > change in its configuration, since I am using it now (Windows Vista,
> > configured months ago).
> > Reported also here on launchpad:
> > https://bugs.launchpad.net/ubuntu/+bug/209602
> > Thank you for your attention.
> > Greetings
> >
> > Luca Venturini
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> John W. Linville
> linville@tuxdriver.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
