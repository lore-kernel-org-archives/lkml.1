Return-Path: <linux-kernel-owner+w=401wt.eu-S1765124AbXGYVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765124AbXGYVIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbXGYVIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:08:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60711 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbXGYVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:08:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=e42rNiJwt7MVndruLl+Y/B3ezyO3NluIv8m9NsFNt27PPGc8lhY7mZp4nmL+thgCR
	IFxIouBhc29qgdrhcFt/Q==
Message-ID: <4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
Date: Wed, 25 Jul 2007 14:07:56 -0700
From: "Masoud Sharbiani" <masouds@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: i386-show-unhandled-signals-v3
Cc: "Andi Kleen" <ak@suse.de>, "Kirill Korotaev" <dev@openvz.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070725140455.cbbc0dde.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718154759.GA26425@google.com> <46A76210.5020903@openvz.org>
	 <200707251657.44217.ak@suse.de>
	 <20070725140455.cbbc0dde.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 25 Jul 2007 16:57:43 +0200
> Andi Kleen <ak@suse.de> wrote:
>
> > On Wednesday 25 July 2007 16:45, Kirill Korotaev wrote:
> > > plz don't enable it by default... :/
> > > any user can spam syslog with these messages and if syslog is run as root
> > > can take the whole diskspace...
> >
> > There are plenty of other ways to cause syslog messages anyways;
>
> tell us what they are and we'll fix them?
>
> > this argument is 100% bogus.
>
> people don't like leaving themselves open to logspamming.
>
>
> For this particular issue: someone please send a patch.
>
Andrew,
This is rate limited; Do you need me to rewrite it with it being
disabled by default?

Masoud
