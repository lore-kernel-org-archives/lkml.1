Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZEEALo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZEEALo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZEEALf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:11:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZEEALe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:11:34 -0400
Message-ID: <49FF83EF.9000702@redhat.com>
Date: Mon, 04 May 2009 21:10:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/21] amd64_edac: add module registration routines
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-22-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1241024107-14535-22-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov escreveu:
> From: Doug Thompson <dougthompson@xmission.com>
>
> Also, link into Kbuild by adding Kconfig and Makefile entries.
>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>   

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro.
