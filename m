Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbXFQWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbXFQWzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbXFQWzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:55:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:35184 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbXFQWzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ESi6PW36pcmsRNp2a10fKow1M3JyG1Jxn2A6it8MctruTq7/Pr0kU2uZeO2+RHcjg8p0ES9rIOlHTmxOXFswU7xiU0F/gTlCzMtaaaziAskXASRnZLsgJEvOoJnMUd8WiCuL77WdGWr/jhLDv8NAUHFxGNG2Te6sI69VPFwmVtc=
Message-ID: <6bffcb0e0706171555p7ce2419eg2c91f40e22111b0f@mail.gmail.com>
Date: Mon, 18 Jun 2007 00:55:30 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: How to improve the quality of the kernel?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706180141.41101.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706180141.41101.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/07, Al Boldi <a1426z@gawab.com> wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 June 2007, Andrew Morton wrote:
> > > We of course do want to minimise the amount of overhead for each
> > > developer. I'm a strong believer in specialisation: rather than
> > > requiring that *every* developer/maintainer integrate new steps in their
> > > processes it would be better to allow them to proceed in a
> > > close-to-usual fashion and to provide for a specialist person (or team)
> > > to do the sorts of things which you're thinking about.
> >
> > Makes sense... however we need to educate each and every developer about
> > importance of the code review and proper recognition of reviewers.
>
> That's as easy to manage as is currently done with rc-regressions.

Are you a volunteer?

It's not an easy task, there are more patches than regressions.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
