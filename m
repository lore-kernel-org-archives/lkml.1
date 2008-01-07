Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYAGMrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYAGMrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYAGMrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:47:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:51294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbYAGMrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=x3k6OFWM7cEqpNFVVL50cec/XiYHN02z8s4ZKZeio+e+FrpamKrewollGb59DvB3+2hiINYTEmJokRwiDwjq7CX7MyC9SluPW85UC26qnOFZQnnNbRh/x+smdX+Rx9G3Z3r/dEY/Tn2IgpmS/RHd2JBBiFeJyCmm8YlgPGIaZfw=
Message-ID: <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com>
Date: Mon, 7 Jan 2008 14:47:10 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michal Simek" <simekm2@fel.cvut.cz>
Subject: Re: New linux arch
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu
In-Reply-To: <47820D24.3060800@fel.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47820D24.3060800@fel.cvut.cz>
X-Google-Sender-Auth: bd45212a640a543b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
> Is it possible to create git repository in git.kernel.org for Microblaze
> cpu?

You need to ask the kernel.org administrators for that:

  http://www.kernel.org/faq/#account

On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
> What are maintainers responsibilities? Do you have any page about?
> I am  U-BOOT maintainer at denx.de and I hope that the responsibilities
> will be similar.
>
> How many maintainers are acceptable? (one or more)

You can have as many maintainers as you want but you probably don't
want to make it too many. There aren't any "official" responsibilities
as a maintainer, it really depends on how much time and effort you're
willing to put in.

On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
> I see the right way to push all changes to public git repository and
> then send patches in small logical group to LKML with CC to people from
> microblaze community.
>
> And then wait for comments from you, solve problems, update git
> repository and send changes again.

You don't necessarily need a public git repository before sending your
patches to LKML but yeah, you definitely want some public exposure
before asking for Linus/Andrew to merge your port.

                        Pekka
