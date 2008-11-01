Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYKAQaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYKAQaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYKAQaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:30:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:37887 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYKAQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=M2PA+/+DqehlLHdPqpAZRuXmYB8V15VLLK4Y29nNkFTteeAaATn1tiK0r2LRZlO2KA
         JLCYc6///yfM6qfUUHCWuN/kt+//pXSCdO+dbzXDB8Xw3BdXabpjCZz39135n05T9pip
         vqdTyZyTbWKUUf0Tw9wj+fFEo0DlQUOSwMX1A=
Message-ID: <84144f020811010929q579bebd7p8760d34631df2fd4@mail.gmail.com>
Date: Sat, 1 Nov 2008 18:29:58 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
       "Markus Rechberger" <mrechberger@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, "Greg KH" <greg@kroah.com>,
       mchehab@infradead.org
In-Reply-To: <412bdbff0811010919v3b336939qf94df1162ecbbb28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	 <412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
	 <84144f020811010908h1220d209j799edca3eb772fd@mail.gmail.com>
	 <412bdbff0811010919v3b336939qf94df1162ecbbb28@mail.gmail.com>
X-Google-Sender-Auth: 49f0a82b9128bdf2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 6:19 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> The reality is that from a technical standpoint I really want Markus
> to be the maintainer.  He knows more about the devices than anyone,
> works for the vendor, and has access to all the datasheets.  That
> said, I don't want a situation where he is the *only* one who can do
> work on the codebase because it is poorly commented and structured in
> a way where only he can understand why it works the way it does.
> Also, I believe certain design decisions should be made as a result of
> consensus with the other maintainers, taking into consideration
> consistency across drivers.

I can understand that you want him to be the maintainer. But so far he
hasn't really shown to be interested in doing that. It's just bit sad
that the we don't have a proper driver given that the code exists and
that there's a person who's willing to do the work to get it merged...
