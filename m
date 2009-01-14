Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbZANUFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbZANUFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZANUFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:05:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:41828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbZANUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iUwCjwy2lhFPA8OUtBbvjmO/KpSjM6XJ4wlXJTV4S4CAL76w7MoXYAS31vR4QZf6b2
         bZdsCfxvmbp2XsBingKKUUI2H6mPEq6OTrAM0Hi/KJui4wy/g1l+gphwyKVhA9FlqKYx
         2uRMZ+glqb/wHJOiXB7uSMVUKT03qTy7M0JEE=
Date: Wed, 14 Jan 2009 23:05:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090114200502.GB8178@localhost>
References: <20090113183456.GA14470@localhost> <496E4040.9080701@zytor.com> <20090114194933.GA8178@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114194933.GA8178@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Jan 14, 2009 at 10:49:33PM +0300]
...
| >
| > Hi Cyrill; in addition to nonexporting COMMAND_LINE_SIZE, could you  
| > submit this as a patchset to make post-integration bisect easier?
| >
| > 	-hpa
| >
| 
| Hi Peter, to be sure -- you mean to make patchset with 5 patches?
| 
| 		- Cyrill -

Of course you mean that, i need some coffee :)
Will do soon.

		- Cyrill -
