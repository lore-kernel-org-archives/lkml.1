Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbXJZRZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbXJZRZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXJZRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:25:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:39696 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbXJZRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=e6XT9rNNPu+I93Kzjw09itAgyUYU7n84pLU6BDkndLCeobUOXVtWaF6SMKiLwLPJewPFEJqBFiYxx8KS4QJt9Ctis9Krx3zPE4pZ2pcD5Ru+tRsrh74tMKuw5fsYSnufM3OWsRPq4dxxNXXTERC4W/KcGnjfDoyVu3eFhZiKR8E=
Message-ID: <877aabc40710261025v2f53423el6bb63fc2024a0ffd@mail.gmail.com>
Date: Fri, 26 Oct 2007 22:55:15 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071026155058.GC23016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
	 <20071026155058.GC23016@kroah.com>
X-Google-Sender-Auth: e3369af2555c8345
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/2007, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> > On 2.6.24-rc1, I get this for all my eth interfaces:
> >
> > [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> > [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>
> I sent out the patch below for comments, yet no one did :(
>
> Can you try it out and let me know if it works for you or not?

No, doesn't help.

-- 
Amit Shah
http://www.amitshah.net/
