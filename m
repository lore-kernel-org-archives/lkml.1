Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYAURFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYAURFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYAURFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:05:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51058 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYAURFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:05:05 -0500
Date: Mon, 21 Jan 2008 22:48:34 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: dAniel hAhler <dhahler@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Regression with idle cpu cycle handling in 2.6.24 (compared to 2.6.22)
Message-ID: <20080121171834.GA31049@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <bcadbdf50801190605s212ebe26n3035d8664554f636@mail.gmail.com> <bcadbdf50801190652s75f36b1ai422d8b12c5e8ff95@mail.gmail.com> <20080120033337.GA8277@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120033337.GA8277@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 09:03:38AM +0530, Dhaval Giani wrote:
> > btw: writing 1 into "cpu_share" totally locks up the computer!
> > 
> 
> Can you please provide some more details. Can you go into another
> console (try ctrl-alt-f1) and try to reproduce the issue there. Could
> you take a photo of the oops/panic and upload it somewhere so that we
> can see it?

I couldn't recreate this problem either on 2.6.24-rc8.

Daniel,
	Could you pass the config file you used pls?

-- 
Regards,
vatsa
