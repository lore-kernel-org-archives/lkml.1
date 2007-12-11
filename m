Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbXLKSjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbXLKSjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXLKSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:39:43 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:22908 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXLKSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NSJaWrU/WCsxIoOoQ5MG2bt+EVX7q34Fb45NXC+/rF3mDhPVKr3R7PHfIdsjUT4BBNyE/mKfy7u2QWByXtMYv8/1BNjoqBaUIkKd9AQCCMyNByBb2FqQg0ZSAsLQpNoyDy0rCMJnfj0jGgbwcuVwaq16puhWeBKbBrlix6aLvvM=
Message-ID: <7b69d1470712111039j6206decboe8d4df866933de0d@mail.gmail.com>
Date: Tue, 11 Dec 2007 12:39:40 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Mauricio Mauad Menegaz Filho" <mmauad@gmail.com>
Subject: Re: HTC TyTN || (P4550) violates GPL?? Or maybe Qualcomm itself with MSM7200???
Cc: "Pavel Machek" <pavel@ucw.cz>, CIJOML <cijoml@volny.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b14f3e280712110902m7e937c78jf972f50c2c20f3f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080115.05608.cijoml@volny.cz>
	 <b14f3e280712071640o76895d73jfd6745ddb3de23dd@mail.gmail.com>
	 <20071209130813.GE4381@ucw.cz>
	 <b14f3e280712110902m7e937c78jf972f50c2c20f3f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2007 11:02 AM, Mauricio Mauad Menegaz Filho <mmauad@gmail.com> wrote:
> > Did phone packaging contain sources or written offer for them? If not,
> > they are probably still violating GPL. gpl-violations.org, I'd say.
>
> Hi Michal/Pavel
>
> Both of you are right. Qualcomm is not offering source codes for the drivers (at
>  least, there is no way to find the drivers on their site, and they
> are probably not
> asking for MSM based devices to advertise *drivers available* or such), nor the
> iguana source code contains the drivers. Licenses are needless until violated.
>
> Mauad

If the drivers are on the L4 side, they would have no obligation to
provide them. That's one of the reasons device manufacturers look at
virtualized/micro-kernel architectures.

Of course, if the device has Linux in it, they would still need to
provide the sources for that, either in the product or via a written
offer.

scott


-- 
scott preece
