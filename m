Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZKGBXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZKGBXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 20:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbZKGBXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 20:23:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:33030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbZKGBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 20:23:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KFnRRxrTSSodosF7zq+XUJFYR6EQS1XBUdd8Xs6q++MRfu3nqfPLoUXpwKsLKFyZ9R
         78FpImsQHr4vUdCojzF7iateJ9o4Ie+zi8zQYZbWmdGldCjwf4zjKKIFlBaaze8AVT3E
         7Bf42RcLs6N7DpXjOEj18g2n0hdYU37Kc3B3c=
MIME-Version: 1.0
In-Reply-To: <20091107000749.GA26070@kroah.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
	 <20091106224728.GA32205@kroah.com>
	 <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
	 <20091107000749.GA26070@kroah.com>
Date: Fri, 6 Nov 2009 23:23:26 -0200
Message-ID: <a4c8a6d00911061723v6017ad7bqf96ba7c905922a45@mail.gmail.com>
Subject: Re: [PATCH] staging/otus: trivial, fix sparse warnig.
From: Thiago Farina <tfransosi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 10:07 PM, Greg KH <greg@kroah.com> wrote:
> Well, for some reason this patch would not apply at all, it looks like
> there are no tabs in it.

I will rebase it and send it again. I hope it will works this time :)
