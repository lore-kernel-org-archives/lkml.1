Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYDBOvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYDBOvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYDBOvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:51:42 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:7521 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYDBOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mA7poGHARyH6umlXZh0XIRN72vktq06Fbf+LR+jR/Kx8LeUUuthe0Dgdo4AQOPqOftmT4J7PQd00+Q2PCWahlGQOlLOGAu0nfVc8FZdIk9xwj6DwB3xqbbQ11jPmpbJ9ZBrnJBEOePFt4RCGvwbiBXo2eCXQfne4LMnz4czr3xY=
Date: Wed, 2 Apr 2008 10:51:32 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix tosakbd suspend
Message-ID: <20080402104921.ZZRA012@mailhub.coreip.homeip.net>
References: <20080401144224.GA6436@USFSHXP-002051> <20080402141632.GA19698@doriath.ww600.siemens.net> <bc64b4640804020738l25b51263la04cff12c38e0325@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804020738l25b51263la04cff12c38e0325@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 06:38:26PM +0400, Dmitry wrote:
> Hi,
> 
> Sorry, that was me... Sometimes I hate git-am & git-format-patch
> 

Heh, you had me scratching my head for a moment ;)

> 2008/4/2, <dbaryshkov@gmail.com>:
> >
> > Fixed two minor glitches. Works for me. Please add it to your tree.
> >

What were they? I dont see any difference from the patch I sent to you,
so I want to make sure I have the correct version.

-- 
Dmitry
