Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXJGTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXJGTj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXJGTjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:39:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:21563 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXJGTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=opIfNuCqxNvrHqNvRK4YETTY+lbeqlYTHgy1b8jRmCVdjDtR+v70twEvru7PzAbACt2rYjWhIKMG1tDkyCEpcUhnvsX21BRYklbRF46p3cN7VZN9DmEo6LceaY2EUKv6AGabX4QswA/Y9v7rVkQi8mYvpwmr7+bae+lN2627Q84=
Message-ID: <86802c440710071239x28c41db2hca6dd7c5bb3c411c@mail.gmail.com>
Date: Sun, 7 Oct 2007 12:39:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 0/5] forcedeth: several proposed updates for testing
Cc: netdev@vger.kernel.org, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4708F194.7080303@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071006151250.GA17020@havoc.gtf.org>
	 <4708F194.7080303@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jeff Garzik wrote:
> > The 'fe-lock' branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git fe-lock
> OK, I've successfully tested patches 1-5 on an AMD64 system with
>
> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)

need to test that with mcp55 based, that will use MSI.

YH
