Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYC0MJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYC0MJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbYC0MJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:09:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:39179 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbYC0MJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ga+KCoJGZNypY1Yg9b+mLjz/3yzCe3ZNfNhmI6ix89Y6ZfQ+Q9iERryFl9MFkOJPgfotR+V318Zva6QaecvPAVcGdt+ff7e3nXRdp85WDa0yU1naGqAWsR3px0+luym+zPXJnZxNnKUMdZc/Vt0G0qfERUpEtm35tUvXqt0t2yE=
Message-ID: <8bd0f97a0803270509k7620e938ldec13f2f260aef5a@mail.gmail.com>
Date: Thu, 27 Mar 2008 08:09:18 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin char driver for Blackfin on-chip OTP memory (v3)
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, wim@iguana.be
In-Reply-To: <47EB8050.4010700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206643758-9319-1-git-send-email-cooloney@kernel.org>
	 <47EB8050.4010700@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 7:09 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Bryan Wu napsal(a):
> > From: Mike Frysinger <vapier.adi@gmail.com>
>  > Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>  > Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
>  Acked-by: Jiri Slaby <jirislaby@gmail.com>
>
>  Will somebody pick the patch up (otherwise cc akpm or I might fwd it)?

not sure what you mean.  Bryan posts the patches for review, and then
any of the Blackfin-specific ones that dont have a subsystem get into
mainline via git pull requests from the Blackfin repo ...
-mike
