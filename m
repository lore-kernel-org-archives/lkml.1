Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZJ0S3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZJ0S3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbZJ0S3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:29:48 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37628 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZJ0S3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u65Qb46v1MCI3UkUaE9LWe6/HLbMyvmmXFx0VPDWaWdHj2rj5jn3SP8zl5Jo3ofkKk
         MVCKBirkNSY+tESxpHpklJCunvG0rEBZiN9lrQaGtcA17VMBOdZ7Ef6ms9l6g9inkOI+
         pQbIQcOOeI/ed9QHBUA46iZlrc/jXkplmLo0A=
MIME-Version: 1.0
In-Reply-To: <20091026084854.GA26990@elte.hu>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
	 <20091026084854.GA26990@elte.hu>
Date: Tue, 27 Oct 2009 14:29:52 -0400
Message-ID: <b4198de60910271129v5765c963rad8d2f4522112986@mail.gmail.com>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance 
	events.
From: Matt Turner <mattst88@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 4:48 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Is there a tree for Alpha bits?

No, but really other than a very few scattered patches we don't have
much activity.

Maybe it's worth creating one at git.kernel.org? I don't think Richard
or Ivan are interested in doing it. Could Michael or I do it without
being maintainers?

Matt
