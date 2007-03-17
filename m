Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbXCQFha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbXCQFha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 01:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbXCQFh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 01:37:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:51316 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640AbXCQFh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 01:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S1krko4gSKOtZXLdry5RracPAFZZkPvZDXc2yftgyZJ90n/VyhIZBErS9ssRQXU7eStA8UxeiAdoONdfLWAcIg+DA+o55UyNs+DQQEVmMub53+mvuG6iefvAkQ6KRlCMZouexKZ/JyHKicjRCuvwP6I7ddXTkCWPiKhwlMyawys=
Message-ID: <170fa0d20703162237m1023cbd2o8ccf9e464c53f4a0@mail.gmail.com>
Date: Sat, 17 Mar 2007 00:37:26 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: forced umount?
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <45FB6E32.3050009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
	 <45FB6E32.3050009@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Mike Snitzer wrote:
> > Is this forced umount work even considered worthwhile by the greater
> > Linux community?  Is anyone actively working on this?
>
> Have a look at all the discussion about revoke/frevoke on lkml over the
> last week or two.

Thanks for the heads up; its good to see that Pekka Enberg's work has
continued.  I actually stumbled onto that line of work earlier while
searching for more info on Tigran Aivazian's forced unmount (badfs)
patches:
http://lwn.net/Articles/192632/

Mike
