Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYLDTHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYLDTHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbYLDTHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:07:13 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:43378 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbYLDTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=qTPU+3ftBBolwvSOfcbWWH5dK6t8J49iNk2edtVMX6EMOrAuXh1x0IWIXrrB9bgM+p
         vKld4JIw0ouKpCJFk9smXZWoCJv4E3PdQ/XaIr4Sq1FthjHAKg76NlLKtVFQpjxtWr+t
         2w5kbU6raKWEBOBXwHqdIxO4e9XQlS4Vwb1fo=
Message-ID: <cfd18e0f0812041107tc898a6ej6361612cf15cd1be@mail.gmail.com>
Date: Thu, 4 Dec 2008 14:07:09 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: clock_gettime not mentioned in time.7
Cc: linux-doc@vger.kernel.org, "kernel list" <linux-kernel@vger.kernel.org>,
       gp@novell.com, fnadge@suse.cz
In-Reply-To: <20081202120223.GA4753@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081202120223.GA4753@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 7:02 AM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
> man 7 time does not mention clock_gettime() (and concept of monotonic
> time at all). I guess it should... at least clock_gettime() should be
> mentioned in "SEE ALSO".

Hi Pavel,

I added clock_gettime() to the SEE ALSO list.  (For man-pages-3.15)

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
