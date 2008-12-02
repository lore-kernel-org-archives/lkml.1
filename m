Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYLBWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYLBWN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYLBWNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:13:47 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:61701 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYLBWNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=AiVVVHLmM56VZNYqcqFGIPIaGHvsbjYQluF3QjF/yDdJZ2I5ah5XASQ6vbhSf4ybJX
         V3/KXimvi0WFlQqsUGxTAyQxvD5h6PV+gEjnqUEYN8aX1jWyXTU9jqYC1rO8uXZesF/G
         Y/wny2sUXzhrNZzjI2tvrwGARdLUOXfQATz7A=
Message-ID: <43e72e890812021413j3c0473a6r7a8a30e7d2602410@mail.gmail.com>
Date: Tue, 2 Dec 2008 14:13:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [PATCH 0/3] ath9k: several fixes ported to 2.6.27
Cc: stable@kernel.org, sfr@canb.auug.org.au, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081202212704.GA31723@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
	 <20081202212704.GA31723@kroah.com>
X-Google-Sender-Auth: 8992feee81b739bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 1:27 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Dec 02, 2008 at 12:51:19PM -0800, Luis R. Rodriguez wrote:
>> This fixes a few issues seen on MacBook Pros:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=11811
>>
>> I've ported them to 2.6.27 to help with them being applied sooner.
>
> What do you mean by "sooner"?  They need to be in Linus's tree before we
> can add them to the 2.6.27-stable tree.  Please let us know when that
> happens, and what the git ids of them are, so we can add them to the
> next -stable release.

Heh, well once applied there it may not apply on 27, so by sooner I
mean that you don't have to do backport work as I did it for you.

  Luis
