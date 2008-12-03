Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYLCWO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYLCWO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLCWOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:14:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:37542 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYLCWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:14:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dnvbxcK01VXQBfHhtnEuC0vV1JLJxjGyQWZUDK9SZ7Dymf7JNWwCo81JwszuRpryDA
         /AKs8dKvAHHtaulCZp3OhC73doyZMV9d2UY22pUJdEo3ZVfaZ3uKzOLvZLjvvJ/Rs/VY
         Fi4AWjBCaHIqZIMn3dqm4mLkYByuH/gzIavPk=
Message-ID: <43e72e890812031414m6a5782e7ga8eed8d91fe056b2@mail.gmail.com>
Date: Wed, 3 Dec 2008 14:14:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX gracefully
Cc: sfr@canb.auug.org.au, ath9k-devel@venema.h4ckr.net,
       "Greg KH" <greg@kroah.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20081203212255.GB4263@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-3-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-4-git-send-email-lrodriguez@atheros.com>
	 <20081203001253.GC14943@kroah.com>
	 <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>
	 <20081203002404.GA22789@tuxdriver.com>
	 <20081203212255.GB4263@tuxdriver.com>
X-Google-Sender-Auth: 903c00d1094e8307
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 1:22 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Dec 02, 2008 at 07:24:04PM -0500, John W. Linville wrote:
>> On Tue, Dec 02, 2008 at 04:20:32PM -0800, Luis R. Rodriguez wrote:
>> > On Tue, Dec 2, 2008 at 4:12 PM, Greg KH <greg@kroah.com> wrote:
>> > > I don't see this patch upstream in Linus's tree.  Am I just missing it
>> > > and if so, do you know the git commit id?
>> >
>> > Nope sorry, John has yet to send his pending-fixes branch to davem and
>> > so forth, which would contain it AFAICT. Please correct me if I'm
>> > wrong John.
>>
>> It has been sent, and Dave sent his pull request to Linus today
>> (or maybe yesterday).  I'll try to dig-up the commit IDs tomorrow.
>
> Hmmm...I seem to have sent this to -next instead.  Since it fixes an
> Oops, I guess I can requeue for 2.6.28.

Pretty please :)

 Luis
