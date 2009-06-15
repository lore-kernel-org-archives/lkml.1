Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZFONRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZFONRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZFONQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:16:55 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57590 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZFONQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:16:54 -0400
Subject: Re: kallsyms broken on ARM by commit 17b1f0d
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <8bd0f97a0906150551o6de9a29fj64f73d4ccfff7e57@mail.gmail.com>
References: <1245070063.16986.22.camel@pc1117.cambridge.arm.com>
	 <8bd0f97a0906150551o6de9a29fj64f73d4ccfff7e57@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 15 Jun 2009 14:16:45 +0100
Message-Id: <1245071805.16986.33.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2009 13:16:46.0234 (UTC) FILETIME=[888C67A0:01C9EDBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 08:51 -0400, Mike Frysinger wrote:
> On Mon, Jun 15, 2009 at 08:47, Catalin Marinas wrote:
> > With the above commit, kallsyms on ARM no longer show correct
> > information. 
> 
> try this patch (Gentoo mail server is broken atm, so attaching)

Thanks. This patch fixed the problem.

-- 
Catalin

