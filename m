Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYAHRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYAHRGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYAHRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:06:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:25794 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYAHRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fbr1uVlQrpoVt+IUnlj5oKIFe68/hzBPofr6tZ8UgZMJIVNj5YxZrs6oSdTUeixeVwvlsPkVRN+sRY2c2Cygx/v25C6mEKIioSBDG25OLYyLJ/rEffvxnzauICK+Nxlh03rgGz819PNAMcevi6OMmmszEJUcZbOmki0a+bQX8FY=
Date: Tue, 8 Jan 2008 20:05:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108170550.GC6307@cvg>
References: <20080108164015.GC31504@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108164015.GC31504@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Tue, Jan 08, 2008 at 05:40:15PM +0100]
| 
| Here's a proposal for some useful code transformations the kernel janitors
| could do as opposed to running checkpatch.pl.
| 
[...snip...]
| -Andi
| 
| 

got it, thanks

		- Cyrill -
