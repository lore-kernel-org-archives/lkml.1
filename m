Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYBTRor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYBTRor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYBTRod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:44:33 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:41195 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYBTRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:44:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C7K8+9upPbJjecSA0ytSCuS8UUPbY6NtRXb6f0CHehykEso/SLURhZEzkkc2iY7nAvGubj0P7rk2s3DT8aKvVvAWZr8q5gLRmUg/ZUlKzC+Rk76vxbJAGNq6iJ3823D5zH1xGPx1j4Yh4249+QLITHJME6JKiSV6j5vQL+sn3Ns=
Message-ID: <72dbd3150802200944s16e84e62tf13c19935915bc55@mail.gmail.com>
Date: Wed, 20 Feb 2008 09:44:28 -0800
From: "David Rees" <drees76@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: very poor ext3 write performance on big filesystems?
Cc: "Theodore Tso" <tytso@mit.edu>, "Andi Kleen" <andi@firstfloor.org>,
       "Tomasz Chmielewski" <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802201156520.26109@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de>
	 <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org>
	 <20080218151632.GD25098@mit.edu>
	 <20080218155725.GB26622@one.firstfloor.org>
	 <20080218153501.GE25098@mit.edu>
	 <Pine.LNX.4.64.0802201156520.26109@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 2:57 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>  But GNU tar does not handle acls and xattrs. So back to rsync/cp/mv.

Huh? The version of tar on my Fedora 8 desktop (tar-1.17-7) does. Just
add the --xattrs option (which turns on --acls and --selinux).

-Dave
