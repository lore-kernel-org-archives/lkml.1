Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbZLGCLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbZLGCLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 21:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbZLGCLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 21:11:36 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54334 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932786AbZLGCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 21:11:36 -0500
Date: Sun, 6 Dec 2009 21:11:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Otavio Salvador <otavio@ossystems.com.br>
cc: Ivo van Doorn <IvDoorn@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       <linux-wireless@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
In-Reply-To: <be7a9f3d0912061422x5a0fd2f6ubd7add33472a8136@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0912062111100.13023-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Otavio Salvador wrote:

> Hello Alan,
> 
> On Sun, Dec 6, 2009 at 8:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > When I use 2.6.32 (or indeed 2.6.32-rc1), it works fine up until the
> > point where the wireless card is ifconfig'ed.  Then not long afterward
> > (a few seconds to a minute) the system hangs.
> 
> Did you test it with 2.6.32? Since 2.6.32-rc1 many fixes has been done
> into kernel and would be nice if you could test against current
> kernel.

The same thing happens with both 2.6.32-rc1 and 2.6.32.  But not with 
2.6.31.

Alan Stern

