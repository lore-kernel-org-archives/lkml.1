Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZGFRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZGFRxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZGFRwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:52:54 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:43963 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751401AbZGFRwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:52:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d4s5Sr8OqCEur/Tm2VQGKOOGasQyatQMItJDxEM6Cpn3R24VC32PqCSL740WK+mK2prKXLBc/SqUHt2ITRpTp7rHv1bxKI358sq3niXlqK325OjyWriWNBzlYqjrGPTh;
Date: Mon, 6 Jul 2009 10:52:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nico Schottelius <nico-linux-20090706@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-r2: Xorg: Black screen
Message-ID: <20090706105249.307e4a6b@jbarnes-g45>
In-Reply-To: <20090706083551.GA6422@ikn.schottelius.org>
References: <20090706083551.GA6422@ikn.schottelius.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 10:35:51 +0200
Nico Schottelius <nico-linux-20090706@schottelius.org> wrote:

> Hello!
> 
> Compared to the other normal brightness problems, with
> 2.6.31-r2 xorg starts, but there is no image displayed
> (neither on internal nor external monitor).
> 
> Switching back to console does not change the status,
> though hitting ctrlaltdel reboots the system (i.e. still
> up and running fine).
> 
> It works with 2.6.30-rc7 (besides sometimes the brightness
> is broken there).

Can you bisect?

-- 
Jesse Barnes, Intel Open Source Technology Center
