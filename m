Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYCBTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYCBTJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYCBTJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:09:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:57262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYCBTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f8PtWKv9+ua2MlvE0DayBKaC1ScYj91vHPjc6VcdSOpGNNqYjc7bN27cjkyqu8R0yXqg1aea/v56eRfEwTS0gFYJsRgHmR0+QeusbDC+mlJVXzw2Sv8t1Y3HpWk+VGe1cdZjcs0D3iGK9O9fBX8nplj+FownjnRUqQ4XDrSGUpc=
From: Pawel Plociennik <paplociennik@gmail.com>
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Date: Sun, 2 Mar 2008 20:09:03 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803011409.59526.paplociennik@gmail.com> <200803021859.30473.paplociennik@gmail.com> <3d8471ca0803021005o46f99282l77d412306877607a@mail.gmail.com>
In-Reply-To: <3d8471ca0803021005o46f99282l77d412306877607a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803022009.04028.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 March 2008 13:05, Guillaume Chazarain wrote:

> You mean pid 1, right? ;-)
Of course that (my brain has been mistaked) :-(
> 
> Sure, but chroot should then exec /sbin/init as per the given kernel
> command line. And then you run a real init.
> 
> I cannot try it as I don't have another distribution installed in a
> subdirectory, but if you could test it we would quickly know if it
> works or not.
> 
You have right.
I have tested that and it  *works* :-)
so I thing that my patch is *unnecessary* now :-(

Thanks You

Regards,
Pawel
