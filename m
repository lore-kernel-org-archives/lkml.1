Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXAVVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXAVVum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXAVVul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:50:41 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:13017 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXAVVul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:50:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=efN1K5c6vT3FUJy2juap+HfRhjrrFMfnUkTwG8VfX9uv2SiEUITcl+MEoo/vwGrlmT0kvguDGI3QZ7MdAN8nPUrEnd4tYvoSRmrgJmzcjh/1CUacivlmJNaXguL84ekeykeFHE7X0kL5i+Qm+K5ET6TVGeRnqd3KxaOlln6tP+g=
Message-ID: <21d7e9970701221350h3a8959faqcd099bf4e0a761fa@mail.gmail.com>
Date: Tue, 23 Jan 2007 08:50:39 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>
Subject: Re: i810fb fails to load
Cc: "Tilman Schmidt" <tilman@imap.cc>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       "Dave Airlie" <airlied@linux.ie>
In-Reply-To: <45B4BF50.9010105@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070111222627.66bb75ab.akpm@osdl.org> <45AAC244.8060607@imap.cc>
	 <20070114162235.4c8d241f.akpm@osdl.org>
	 <45B4BF50.9010105@tungstengraphics.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >>
> >
> > Don't know.  But I bet someone on the Cc does...
> >
> Tilman,
> Thanks for reporting.
> Can you try the attached patch to see if that fixes the problem.
>

Hi Thomas,

This also fixes X starting on old i810/5 hardware, I had noticed it
broken but hadn't had time to investigate it, this patch fixes it...

Dave.
