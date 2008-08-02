Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYHBJRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYHBJRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 05:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYHBJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 05:16:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:15348 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYHBJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 05:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G82SjQ0crzWa7PQoXj4OzYSY15X2uvDJEg+USE4E9j2HzyrSPRa7WiZ0LyXHAqFnA/
         wp2SSGwb0EM/5SKQVW4Ji9WipLAiP3yUkar875cKfmliy7uoC+Q6v4fzVgVybuRqWfCv
         804ZJo5qw7gVJy0sVmhyVwc3cSuORlrO0NCq0=
Message-ID: <1ba2fa240808020216i320e97e6j9510597f5b3daf83@mail.gmail.com>
Date: Sat, 2 Aug 2008 12:16:47 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-08-01
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080802032946.GA29921@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080801205830.GA10071@tuxdriver.com>
	 <1ba2fa240808011443u1a5553fpfca046f047773217@mail.gmail.com>
	 <20080802032946.GA29921@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 6:29 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Sat, Aug 02, 2008 at 12:43:32AM +0300, Tomas Winkler wrote:
>> On Fri, Aug 1, 2008 at 11:58 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > Dave,
>> >
>> > Another big batch of wireless fixes for 2.6.27.  The ath5k series is
>> > more than fixes, but I included it because it enables new ath5k
>> > hardware.  (The ath5k.h changes in particular are documentation cleanups
>> > for registers based on info gleaned from the newly posted ath9k driver.)
>> > The others patches are fixes, some more obvious than others. :-)
>> >
>> > Let me know if there are any problems!
>>
>> All the iwlwifi patches should go up otherwise the support for 5000 HW
>> will be incomplete.
>
> Then they should have been posted before 2.6.26 was released...

Unfortunately I cannot align development progress with kernel
releases. This cat is not tatural for the driver. But this time all
the patches that went out after 2.6.26 are bug fixes maybe except
module renaming patches. There are no new features added all we do is
cleaning up our bug reports.
Hope we won't end up with not working driver like in 2.6.26.
Tomas

> --
> John W. Linville
> linville@tuxdriver.com
>
