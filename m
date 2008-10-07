Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYJGBMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYJGBMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYJGBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:12:26 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48025 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYJGBM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=b1U3gHcsHPzdfBy8XCWM4972g4rKudjJxkJ3OucPzfTOkurOi11gPbz9QUNQflwyXC
         f84UAAafyviHbR0rSZ8kzkz9E0qp9PZIHs2hyv6NMr7EM67T+RIbAiZqhpdMcWSSj4IT
         o/kwkO2HoWyIj6aDpUhvHefGB9V0/jPhxegdM=
Message-ID: <48EAB71B.1050002@gmail.com>
Date: Tue, 07 Oct 2008 10:10:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: gettinther <gettinther@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata dvdroms fails to be recognized by MCP55 controller with
 the 2.6.26.5 kernel
References: <64630f150809291601w3511febdyc769b8871db75602@mail.gmail.com>	 <20080930170849.52c00228.akpm@linux-foundation.org>	 <48E2E8A1.8090204@gmail.com>	 <64630f150810010131g18c1a00m91b3f68ea29a1067@mail.gmail.com>	 <64630f150810011601y4e729decq24c614f0b7994f3f@mail.gmail.com>	 <48E71ACE.4000505@gmail.com> <48E71AEC.8020701@gmail.com> <64630f150810060208q22b61900xd7487500eac4e145@mail.gmail.com>
In-Reply-To: <64630f150810060208q22b61900xd7487500eac4e145@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gettinther wrote:
> I have tested the patch you sent me and it solves the issue with the
> sata dvdrom detection with the 2.6.27.rc8.  The issue is still present
> on the 2.6.26.5 kernel.  Are you backporting the solution to that
> kernel?

It seems nf2/3 still have issues.  Once nf2/3 are cleared, I'll
forward the patch to -stable.

Thanks.

-- 
tejun
