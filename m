Return-Path: <linux-kernel-owner+w=401wt.eu-S1030649AbXDVMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649AbXDVMix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030778AbXDVMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:38:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:2504 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030649AbXDVMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hnpAYObE2uCvsWpDzBbqbwO7DWdqltIe4x3pkI1/3H97doowqjoGcS/EQWcT502jjTzjxthOHiiz+J2BclMmDnbHz5gdIUMSr9SlC4dab0kaDXTuZ+tIv8DQYa3t3eFguY4CwKhnDYC2SoSLxYiD/rnPdaeFQ3t4FMSR5V4tjo4=
Message-ID: <653402b90704220538gf0041f1yf699cc8aa5f200e8@mail.gmail.com>
Date: Sun, 22 Apr 2007 14:38:50 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "oliver pinter" <oliver.pntr@gmail.com>
Subject: Re: [BUG? -rc7] SMP: Just one CPU activated: P4 3GHz HT
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6101e8c40704220453v544dce39j9e348939b3cb1f2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <653402b90704220157h5fe2be3p18c4a341d13ccc87@mail.gmail.com>
	 <6101e8c40704220300n4cfef0f1l652b303f5bab8d1b@mail.gmail.com>
	 <653402b90704220312k24ed730ay204ccd076dab8d6c@mail.gmail.com>
	 <6101e8c40704220453v544dce39j9e348939b3cb1f2e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, oliver pinter <oliver.pntr@gmail.com> wrote:
> I have CC the kernel

Did you?

> and the result is:
>
> your'e config : failed smp
>
> your'e config + power managment : ok
>

Interesting, can anyone tell me why does not SMP work without Power
Managment? Should it be that way?

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
