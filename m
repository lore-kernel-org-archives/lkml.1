Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZKVPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZKVPka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZKVPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:40:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:23514 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbZKVPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Yiy4GviEY4MqEQDqbZx0GMASIVCBBdqiIR9zVDO8GpZR9ERtBCG8dm6wGE+iDcpsN3
         Cu1CP4UCMLDtOu0QjnnhSGf8GNqnVG3T2KPRRJP3jmc7qEfkR84foNt6dAabADghAB3h
         +kFHSfEOXl4hElJoaKnqdoYsTnDw8WXgtl0Fc=
MIME-Version: 1.0
In-Reply-To: <1258555133.3454.2.camel@hammer.suse.cz>
References: <20091118090100.GA1399@ucw.cz> <1258555133.3454.2.camel@hammer.suse.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 22 Nov 2009 09:33:35 -0600
Message-ID: <f17812d70911220733va9997a1ibb6bbc8551f9c613@mail.gmail.com>
Subject: Re: 2.6.32-rc7: compile regression on spitz
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/18 Stanislav Brabec <utx@penguin.cz>:
> Pavel Machek wrote:
>> If CONFIG_AKITA is not set, spitz fails to compile. It worked ok in
>> rc5. Fix is one more ifdef...
>
> That was my mistake in 5e0fa3f.
>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Stanislav Brabec <utx@penguin.cz>
>

Applied to 'fix'.
