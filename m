Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbYLFBFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbYLFBFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYLFBEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:04:55 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:36875 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYLFBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jJ3+qJ6tPVUiSiSgp+AlEmseUkPoWbvhm6s5BBa8r5q1XBa3aOwQ6CpbJaIOB8UfnQ
         LW6TKmqIQV9Y6c2RVX9H4MtG8PLsTdjhFeyTNyGOKeDX18gzKS7jwEpj/HDp8hzc4cfK
         BtFBmeoReaZokMijJ5b83SzX9UupL5yg43dIc=
Message-ID: <2375c9f90812051704oa80cafeif17909e332178d6e@mail.gmail.com>
Date: Sat, 6 Dec 2008 01:04:52 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: Geralt <usr.gentoo@googlemail.com>
Subject: Re: Shebang - why are parameters not splitted on whitespace?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fbdd0e50812030929s2d573981k46757c1b706f4cd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
	 <2375c9f90812030756r5b8840e1u3980ddca8df27a6b@mail.gmail.com>
	 <fbdd0e50812030929q65d2e805y49094dd67209be7e@mail.gmail.com>
	 <fbdd0e50812030929s2d573981k46757c1b706f4cd5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 5:29 PM, Geralt <usr.gentoo@googlemail.com> wrote:
> Hello,
>
> I should have anticipated this objection :-). I'm aware that this is
> not consistent among Unix operating systems (you can find more about
> it here [1]), but I was specifically refering to linux in this case
> and why it handles the shebang arguments as one big string and not as
> single arguments for the application.

I can't think out any strong reasons, maybe only becasue Linux developers
prefer that approach.

Thanks.
