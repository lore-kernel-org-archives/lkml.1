Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYGQKQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYGQKQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYGQKQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:16:10 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:40677 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYGQKQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wvYasa4jDbN9n0YsrlGsK9Fah1UUBU3JdCIn/jO8zUvi4s8iySwSwas/1mpVZHT3Uv
         Px0LxjbvttY5Jc+UOZFFK79mBPoukn5PodQK47ds4GplRNPg+4X/Qx83C57cFPco4JwY
         pd9kiUXjaIHFTd9+lqpdpXkrbNUizsc7csIAs=
Message-ID: <43e72e890807170316xcd6528cpcef4a8f669a22d08@mail.gmail.com>
Date: Thu, 17 Jul 2008 03:16:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2nd REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080716184803.GB3232@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709190915.GA8238@tuxdriver.com>
	 <20080715182654.GA5969@tuxdriver.com>
	 <20080716184803.GB3232@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:48 AM, John W. Linville
<linville@tuxdriver.com> wrote:

> I'm still looking for more/different topics

A couple I can think of:

* Compat-wireless, this can be discussed after new MQ patch. We may
have to freeze mac80211 for old kernels for compat-wireless after the
MQ patch goes through and only leave in it fixes moving forward. This
consideration is because porting the MQ patch may be very difficult to
maintain. It was expected though that the first MQ patch could not be
ported though so we'll see, we just might be able to port this
properly. We can talk about this further at the summit.

* Testing -- lets get serious about automation of testing. The Orbit
grid is still available, we just need to put together scripts and test
scenarios.

* Rate control cleanup -- this needs to a good review and cleanup.
Probably not high on our priority list though. We can talk about this
further during the "rate scaling algs" section on the agenda.

  Luis
