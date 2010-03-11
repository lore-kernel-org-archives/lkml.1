Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0CKL0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:26:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34577 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0CKL0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:26:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QPVMFX5ejXAZOrFooeclqUGWq2tGnD/95Cp7b9FOgtTO7QlpOsW2A0K7fqxbTbZT8N
         ELigWtVGIlC/jSoJA+ns+nOadu5bYwpMdXz03SfrkWq0q5rXmove1awf7Pqmip1dxUXM
         g+SbStwp1YgAQJ0u7qsrJFZSgxyIisiFjNVnE=
MIME-Version: 1.0
In-Reply-To: <4B98BC40.1030306@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>
	 <4B973CF6.4030009@st.com>
	 <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>
	 <4B977067.3050108@st.com>
	 <63386a3d1003102243w637a8ce1m838a2dba946add32@mail.gmail.com>
	 <4B98BC40.1030306@st.com>
Date: Thu, 11 Mar 2010 12:26:08 +0100
Message-ID: <63386a3d1003110326h44ac3fb7q88aa557fc010a763@mail.gmail.com>
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr 
	platform
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Shiraz HASHIM <shiraz.hashim@st.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/11 Shiraz HASHIM <shiraz.hashim@st.com>:

> Can we use clockevents directly? I though they are abstracted by the kernel
> framework and using them directly is not advisable/feasible.

Not that I know, but as tglx says it might soon be possible to do so, and if
you have a patch for using some surplus clockevents for this along with some
example of it actually being used too, people will probably react,
atleast they will have opinions.

Yours,
Linus Walleij
