Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbZFONX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbZFONX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbZFONXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:23:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43952 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbZFONXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:23:47 -0400
Date: Mon, 15 Jun 2009 15:26:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kallsyms broken on ARM by commit 17b1f0d
Message-ID: <20090615132603.GA13175@uranus.ravnborg.org>
References: <1245070063.16986.22.camel@pc1117.cambridge.arm.com> <8bd0f97a0906150551o6de9a29fj64f73d4ccfff7e57@mail.gmail.com> <1245071805.16986.33.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245071805.16986.33.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 02:16:45PM +0100, Catalin Marinas wrote:
> On Mon, 2009-06-15 at 08:51 -0400, Mike Frysinger wrote:
> > On Mon, Jun 15, 2009 at 08:47, Catalin Marinas wrote:
> > > With the above commit, kallsyms on ARM no longer show correct
> > > information. 
> > 
> > try this patch (Gentoo mail server is broken atm, so attaching)
> 
> Thanks. This patch fixed the problem.

Quick testing - good.
I will forward this to Linus tonight.

	Sam
