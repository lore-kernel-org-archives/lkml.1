Return-Path: <linux-kernel-owner+w=401wt.eu-S934921AbXGLQd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921AbXGLQd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759794AbXGLQdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:33:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:43641 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086AbXGLQdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GMkwJs0QDlN+akXxB4J7q5qZvIFtFT+JczoaujtV5XfZ5WaVVFcaINa+LU3VxITqI6LQbqJaS2aDtMX50xSWuAnxsI02AMY8TktlDKjiycbbNq++5kOoB5UwBrRZNXVqESV7vAb9jYDCbqxagDDRzeSvp+jquKSKTUPdtP/jYSY=
Message-ID: <78ecab220707120933q31a4efb5tb6dbed7a4787f5a@mail.gmail.com>
Date: Thu, 12 Jul 2007 12:33:18 -0400
From: "Mark Shelby" <mshelby1@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel autoconfig option?
In-Reply-To: <20070712161402.GA18550@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
	 <Pine.LNX.4.64.0707121635120.25352@fbirervta.pbzchgretzou.qr>
	 <78ecab220707120802p11ab3e1fye497f4107fe18c1d@mail.gmail.com>
	 <20070712161402.GA18550@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, greg... Just wondering... If this topic comes up every 6
months or so -seems like there is a "need" for this sort of thing.
Wonder why it has not been implemented yet? Especially if as you say
the system calls are out there already to do it -when you know the
right commands to type in.

Just curious... In my never ending quest to make Linux accessible to the masses
:-)


I'll look up the info and try what you suggested.


On 7/12/07, Greg KH <greg@kroah.com> wrote:
> On Thu, Jul 12, 2007 at 11:02:15AM -0400, Mark Shelby wrote:
> >  That's an excellent idea. I am still thinking along the lines of
> >  "idiot proof simplicity." It would be nice to have a configure script
> >  that scanned your system board, sound card/chip various input ports,
> >  etc, and went ahead and preselected those to build when you type
> >  "make.
> >
> >  If you could combine this with the make "allmodconfig" command in a
> >  user friendly interface, I think you'd really be on to something!
> >  --as long as it's still configurable after the preselected choices are
> >  made.
>
> Check the archives, this comes up every 6 months or so.
>
> Also, you can just use the simple scripts as described in the book,
> "Linux Kernel in a Nutshell", free online, to do most of what you are
> looking for here (automatic detection of what driver is needed for what
> device.)
>
> good luck,
>
> greg k-h
>
