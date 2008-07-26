Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYGZVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYGZVmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 17:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbYGZVmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 17:42:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:49345 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbYGZVmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 17:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bX5W8/mPlkQ4KqoZywaRrbOR/VGIlpoZPCiYY4XYwC2fxaVvJFiLy946xIxOzPIq3p
         EXonpg9RekI3AlgywzxhdAbjMc7YCW/rAXvHfDLQzdcTXCu/VYXo9FLVXgRmduLoNTkm
         k3xDFygCfKOhJQ+rQxygdhI0KsdPEwJDvvPfE=
Message-ID: <1ba2fa240807261442n1d8c08fcv9384957e3325cecc@mail.gmail.com>
Date: Sun, 27 Jul 2008 00:42:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Junty Mesmon" <jmesmon@gmail.com>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
       "Zhu Yi" <yi.zhu@intel.com>,
       "=?ISO-8859-1?Q?St=E9phane_Jourdois?=" <stephane@jourdois.fr>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f2efd86c0807252030t1d73f4ffu8b23d6221f8f3212@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
	 <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
	 <4885DDC4.2060609@googlemail.com> <4886235F.6010407@jourdois.fr>
	 <1216951133.2705.227.camel@debian.sh.intel.com>
	 <69e28c910807251449h6e389cd2n72de63c558338335@mail.gmail.com>
	 <f2efd86c0807252030t1d73f4ffu8b23d6221f8f3212@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 6:30 AM, Junty Mesmon <jmesmon@gmail.com> wrote:
> If this is the right place to do it, i would like to confirm that i
> have had success injecting data packets with the stated patchto the
> iwl4965 driver.
>
> On Fri, Jul 25, 2008 at 5:49 PM, Stefanik Gábor <netrolller.3d@gmail.com> wrote:
>> 2008/7/25 Zhu Yi <yi.zhu@intel.com>:
>>> On Tue, 2008-07-22 at 20:13 +0200, Stéphane Jourdois wrote:
>>>> but this commit is for iwl3945, not iwl4965.
>>>> The patch for iwl4965 is currently not in any git tree.
>>>
>>> We are waiting for more "confirmed success" response before merging it.
>>>
>>> Thanks,
>>> -yi
>>
>> I think we now have a lot of "confirmed success", as aircrack-ng users
>> are now using this card with aireplay-ng - injecting association
>> frames is unstable, but injecting data packets works.

That I don't have doubt the question whether it didn't break normal operation.
Tomas
