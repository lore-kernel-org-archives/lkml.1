Return-Path: <linux-kernel-owner+w=401wt.eu-S935822AbXGUNrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822AbXGUNrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761851AbXGUNre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:47:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:36922 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbXGUNrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DnKTZGxouUJ3zfmCDH0FX4f7uCzo14CFXoCbKjbk4ltSVT1t/JgN7qPo/GOYXc/xv5qwAP5EYG3APv5xyjqAhpGJear4KoRk+Mn84Ak1vmD2+MoTTo4DhpuUV6Y4o5mVT5+lq8qMSBz5mIJAih7HpEN1t890tuFOWlS0kEhIY5k=
Message-ID: <91b13c310707210647y1987683fxaaf23d0e6df6fbba@mail.gmail.com>
Date: Sat, 21 Jul 2007 21:47:31 +0800
From: "rae l" <crquan@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Cc: "Matthew Wilcox" <matthew@wil.cx>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46A1A375.3020900@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184489571313-git-send-email-crquan@gmail.com>
	 <4699EEA9.6070709@simon.arlott.org.uk>
	 <20070720170743.GF14791@parisc-linux.org>
	 <46A0F282.8070103@simon.arlott.org.uk>
	 <20070720180019.GJ14791@parisc-linux.org>
	 <46A1A375.3020900@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> Changing the code to fix a utility bug is madness. I think it's been
> fixed too...
Now I also think it's the utility's bug, that hardly do nothing on
indent the source.

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
