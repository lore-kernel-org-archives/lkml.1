Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbYKYQzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbYKYQzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYKYQyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:54:49 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:29463 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYKYQys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=iCp13eY7DGhbGqHhpfsfgvT6wLH/Z1yM7syVKijTfNjZu4u3mr498l8FpGdCEoBK1v
         Jf3QT7iIqMGthz21cv25NAgvOmulfo1bOIMXdROgUZNVaWwsCbj1MYvQaEYEVNI1CBeI
         VtXtSMmkk7znMzPAQYQhkksgwjBQ08LZ9noV0=
Message-ID: <cfd18e0f0811250854r20707d53u629245e478fb8d69@mail.gmail.com>
Date: Tue, 25 Nov 2008 11:54:46 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Rodolfo Giometti" <giometti@enneenne.com>
Subject: Re: [PATCH 1/9] LinuxPPS core support.
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Jones" <davej@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Greg KH" <greg@kroah.com>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081125164512.GE26417@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1227542451-31969-1-git-send-email-giometti@linux.it>
	 <1227542451-31969-2-git-send-email-giometti@linux.it>
	 <517f3f820811250824ubb4ca0bn5a8be62a180581e4@mail.gmail.com>
	 <20081125164512.GE26417@tekkaman>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 11:45 AM, Rodolfo Giometti
<giometti@enneenne.com> wrote:
> Thanks for your suggestions! I'm going to fix them ASAP.
>
> On Tue, Nov 25, 2008 at 11:24:57AM -0500, Michael Kerrisk wrote:
>>
>> Antennas is I believe the more common English plural.
>
> In the past I got a suggestion in using «antennae» instead of
> «antennas»... do you think I can leave it anyway? :)

Take a look at this thread:

http://forum.wordreference.com/showthread.php?t=93958

and

this article:

http://en.wikipedia.org/wiki/Antenna_(radio)

Weight of usage seems to be "antennas" when we are talking about radio devices.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
