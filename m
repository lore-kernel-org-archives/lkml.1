Return-Path: <linux-kernel-owner+w=401wt.eu-S937152AbYEUUbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937152AbYEUUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760955AbYEUUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:31:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:25476 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504AbYEUUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=g8vLOg2tQ+/iCRZutjkXEP8GiHuz1+yI5/vpx/A9OjwR//FOTyN+kNjBUTZ8DT/LnLbc4RWFN+3AzSNlvA1THBi7beyOnmEBarMwfW7kqnkRj8bfDhWGt9iWeEerqea35HN8iPwWq2/TSzB/Ec9n/qlNJvIb/AMZD+AJTaT/j0I=
Message-ID: <75b66ecd0805211331r6b2e079wc4d028d368463e49@mail.gmail.com>
Date: Wed, 21 May 2008 16:31:38 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: completely lost as to what to do, or where to look.
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <2c0942db0805211309y2871009fv34669d384df820d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
	 <20080520223410.9a8f200d.akpm@linux-foundation.org>
	 <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
	 <20080521075917.GB18352@cs181133002.pp.htv.fi>
	 <dd18b0c30805210733m6d853709xf59331cfed3bfea@mail.gmail.com>
	 <6101e8c40805210751y350e3513ndd48621ac9d2b5d3@mail.gmail.com>
	 <dd18b0c30805211004m6106b65occ97eff00cdbf630@mail.gmail.com>
	 <dd18b0c30805211303k6e43d6d1l903da0c794521519@mail.gmail.com>
	 <2c0942db0805211309y2871009fv34669d384df820d4@mail.gmail.com>
X-Google-Sender-Auth: de59d5bbabd128b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 4:09 PM, Ray Lee <ray-lk@madrabbit.org> wrote:
> Or are you using the closed-source nvidia drivers? (No judgement from
> me if you are, but it would really help clear up what the heck is
> going on.)
>

Yes, the whole problem was that he was trying to use an incompatible
kernel with the closed source ATI driver.

Lee
