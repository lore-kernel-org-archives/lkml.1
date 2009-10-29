Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZJ2QrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZJ2QrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZJ2QrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:47:22 -0400
Received: from outbound-mail-309.bluehost.com ([67.222.54.2]:60413 "HELO
	outbound-mail-309.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755409AbZJ2QrV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:47:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oZzCke9qIjHlx3FgZew5ikOTV8gvHylXEYAed+fBLVBEfZ5KIojcohB3tya6VCj2Csn8pc1AqxsNUZ3TA2ZG95FIDgKEEQii+TZXkiCZLMwuBHePeHMD/zBbWzFFCseO;
Date: Thu, 29 Oct 2009 09:47:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [resend] i915: high power consumption after suspend/resume
Message-ID: <20091029094723.7e5a3376@jbarnes-g45>
In-Reply-To: <cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	<cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	<20091005092148.4341d9ab@jbarnes-g45>
	<cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 23:44:35 -0400
Andrew Lutomirski <luto@mit.edu> wrote:
> > I probably need to save/restore some more of the power saving state
> > across suspend/resume...  Can you file a bug for this at
> > bugs.freedesktop.org so it doesn't get lost?
> 
> Submitted as https://bugs.freedesktop.org/show_bug.cgi?id=24386

Andrew, are you still seeing this after the various fixes that have
landed in Linus's tree?

-- 
Jesse Barnes, Intel Open Source Technology Center
