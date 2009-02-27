Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbZB0X2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbZB0X2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZB0X2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:28:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:55580 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZB0X2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xiFsjBRcI5sZwkoCreF8snJkDi5LVFiBEwO6BuuxJjPb8IewSPAZ4xcCMkRIpIDfK7
         Hc4YlDykmvmexS7XU3DI/gu9LChyphw6Wr71t5x2xheJv8Z8Kpg5t9z5HsT4OawRoqA8
         Xt0l+FpjTNkuGPbytLnd7umMrnoudpI2E85+k=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0902271524h781300f3kec327de34ab7ccb5@mail.gmail.com>
References: <20090224160346.5FF5E10800E@picon.linux-foundation.org>
	 <200902252339.10129.rjw@sisk.pl>
	 <b6a2187b0902251738pd7be00ftf415ea6b6bf10329@mail.gmail.com>
	 <b6a2187b0902271524h781300f3kec327de34ab7ccb5@mail.gmail.com>
Date: Sat, 28 Feb 2009 07:28:04 +0800
Message-ID: <b6a2187b0902271528n7bad07c9rf2c56e614780d692@mail.gmail.com>
Subject: Re: [Bug 12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bugme-daemon@bugzilla.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 7:24 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:

>> I just tried it and still doesn't work. May be it's this particular
>> AP, but I tried on another hidden AP and it's not much better.

I just to clarify that this association problem only happens with
"hidden AP". 2.6.28 to 2.6.29-rcX works just fine with non-hidden AP.

Thanks,
Jeff.
