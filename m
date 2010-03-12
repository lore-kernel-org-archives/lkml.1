Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab0CLGCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 01:02:08 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59891 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0CLGCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 01:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LafkabuWfXhArlk1pDFi04JCEGGF0ny8NH3GPIgkfvUJi6ajb5Pcpv/ZcrVBOl9zDf
         9EzgZJqXMjGFfFccxm6m4WW+hr55ulcYHgVJADOIX4FEFRJRsjEnmKFxp44VJp3j40uW
         rKt7l7LeSQ/OhuhIo9tcUQ+/XkSQ9n2QVppv8=
MIME-Version: 1.0
In-Reply-To: <20100312025330.GA15402@tuxdriver.com>
References: <43e72e891003111722n4b4d5b6crf764dfe357ff8965@mail.gmail.com> 
	<69e28c911003111756h224ef6a9x622c979232b6698b@mail.gmail.com> 
	<20100312025330.GA15402@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 12 Mar 2010 07:01:42 +0100
Message-ID: <69e28c911003112201j6917d7b3t87cc981a0d9f03eb@mail.gmail.com>
Subject: Re: cfg80211 conversion of all drivers
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, devel@driverdev.osuosl.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/12 John W. Linville <linville@tuxdriver.com>:
> On Fri, Mar 12, 2010 at 02:56:31AM +0100, Gábor Stefanik wrote:
>
>> May I ask you why hostap is "to be killed"? What is the alternative?
>
> I think that is code for "replace it with something based on mac80211"...

Isn't Prism2 a Fullmac chipset?

Anyway, as I hoped for, it is not "kill in favor of orinoco" (which
also has some support for Prism2, though not as good as hostap).

>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
