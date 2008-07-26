Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYGZDay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYGZDay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 23:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYGZDap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 23:30:45 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:4375 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYGZDao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 23:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TItEvna9MbmJeBPUkbPaP7yj3tyWygkoCEkA0DOZQgWm7jbPJSjHTMBsDE3ddRubue
         GhqMdC+GO1kBcP4sB4UIgaHC2ctSLh7CjH1VNG+/IMyv3v+CBzXZR1485EM7npLOCson
         Sg4mOtqxRxkEpUvkSdE4CrHLtgEmPW8Ominho=
Message-ID: <f2efd86c0807252030t1d73f4ffu8b23d6221f8f3212@mail.gmail.com>
Date: Fri, 25 Jul 2008 23:30:43 -0400
From: "Junty Mesmon" <jmesmon@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: "Zhu Yi" <yi.zhu@intel.com>,
       "=?ISO-8859-1?Q?St=E9phane_Jourdois?=" <stephane@jourdois.fr>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <69e28c910807251449h6e389cd2n72de63c558338335@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
	 <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
	 <4885DDC4.2060609@googlemail.com> <4886235F.6010407@jourdois.fr>
	 <1216951133.2705.227.camel@debian.sh.intel.com>
	 <69e28c910807251449h6e389cd2n72de63c558338335@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this is the right place to do it, i would like to confirm that i
have had success injecting data packets with the stated patchto the
iwl4965 driver.

On Fri, Jul 25, 2008 at 5:49 PM, Stefanik Gábor <netrolller.3d@gmail.com> wrote:
> 2008/7/25 Zhu Yi <yi.zhu@intel.com>:
>> On Tue, 2008-07-22 at 20:13 +0200, Stéphane Jourdois wrote:
>>> but this commit is for iwl3945, not iwl4965.
>>> The patch for iwl4965 is currently not in any git tree.
>>
>> We are waiting for more "confirmed success" response before merging it.
>>
>> Thanks,
>> -yi
>
> I think we now have a lot of "confirmed success", as aircrack-ng users
> are now using this card with aireplay-ng - injecting association
> frames is unstable, but injecting data packets works.
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
