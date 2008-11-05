Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYKEVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYKEVvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbYKEVvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:51:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:35272 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYKEVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wFzTRwoQzFxkRmkDvypIFBqjN3GAd5ecsE87uqAtk3V2AqDXJBx13fqqS3AocSnskJ
         A1wIr+gLFxSy5N+HxQ1Jc7IK1BcqHcaoimYGeZ0uQSCVZ66cbHNBMcbTK9fhz8AKZtdu
         82rwthu6qG69Gvsf1DQzzlYScDUkGvYbxBHsA=
Message-ID: <9e4733910811051351r3682dc1erc67d04d92142c4e2@mail.gmail.com>
Date: Wed, 5 Nov 2008 16:51:31 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [RFC PATCH V4 1/6] Minimal changes to the core input system
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081105213828.GA3966@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105194640.19407.19682.stgit@localhost>
	 <20081105194738.19407.31117.stgit@localhost>
	 <20081105213828.GA3966@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 4:38 PM, Pavel Machek <pavel@suse.cz> wrote:
> On Wed 2008-11-05 14:47:38, Jon Smirl wrote:
>> Minimal changes to the core input system. The bulk of IR support loads as a module. These changes are passive if the rest of IR isn't loaded.
>>
>> Jon Smirl
>> <jonsmirl@gmail.com>
>
> Apart from too long lines in changelog and missed Signed-off-by: it
> looks okay to me ;-).

I'm not looking to get it into the kernel yet, it still needs some
more eyes looking at it to make sure the API are ok.


-- 
Jon Smirl
jonsmirl@gmail.com
