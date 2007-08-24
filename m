Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbXHXOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbXHXOmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXHXOly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:41:54 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:39447 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbXHXOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D62nCCnslJwgbNT+JbKqcNRfer/HnsEWT8oEO4VGEqSYK69zqR1vZwkZHEVN4ZKzB+UlBf4KY2+ahRym/Uydi+5KmwCD0vew1q7kZupfpX9THvc+Je1XE6pCOgzFND9CqeogdhIWeymSRCpmbwLvxiE7+2bUTTGLS6MGjpH3oU8=
Message-ID: <443c85430708240741s67fb978cmdcdcbe6dac7ef1a6@mail.gmail.com>
Date: Fri, 24 Aug 2007 10:41:51 -0400
From: TheOneKEA <theonekea@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: Possible problems reading a DVD-RAM disc
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070824135812.GH9412@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <443c85430708231944s102dff82u366a93824f7c2222@mail.gmail.com>
	 <20070824135812.GH9412@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Aug 23, 2007 at 10:44:55PM -0400, TheOneKEA wrote:
> > While doing a long mega-copy from one side of a DVD-RAM disc formatted
> > with the vfat filesystem to an smbfs network share, I got lots and
> > lots of these in the dmesg:
>
> No idea about the error, but isn't vfat torture of a dvd-ram?  Don't
> they come preformated with UDF since it does wear leveling while vfat
> would very very quickly trash the part of the disk storing the FAT.

I wouldn't know - someone else gave the media to me and wanted to try
to rescue the data on it. I certainly didn't out vfat on it on
purpose. As soon as I can fix the dmesg errors and get a clean read of
the disk, I intend to clean it off and put UDF on both sides.

-- 
SCREW THE ADS! http://adblock.mozdev.org/
