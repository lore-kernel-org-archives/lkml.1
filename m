Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYAIDY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYAIDY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYAIDYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:24:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:12842 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYAIDYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JZB4jefU7G4/vv1751LbYE/6OzlPFtPxNwu6dI87LQiQN66/EkI3p+r2dlrcSUah1tyozyXLbu8MvX5cPDnTM/DpCik86bzSicczCP7vact7FuibGNkgp13z1Sk12Lid/DbpOdxw2+wJztehCaphvb4at+oKHguMB1x5U6i9580=
Message-ID: <6d291e080801081924p749ae6d2x1618fb7c234c8c22@mail.gmail.com>
Date: Tue, 8 Jan 2008 21:24:36 -0600
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel Oops?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080109030215.4e3f0992@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
	 <20080107233008.0c1b928c@lxorguk.ukuu.org.uk>
	 <6d291e080801081825g951ef59j1eb37d6b43f11ec5@mail.gmail.com>
	 <20080109030215.4e3f0992@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 9:02 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Except this time when rebooting the machine i got a kernel oops
> > message and it didn't boot completely. I could not copy it but I did
> > take a picture and now I have re-written the screen here(sorry about
>
> That is interesting - that sort of error usually points at memory
> corruption and early on tends to point at hardware (but not always). What
> hard is in this system  and does it have over 4GB of RAM ?
>
>

There are 2GB of RAM and the motherboard is DFI and it has a duel core
intel cpu. If you need to specifics I could look them up.
