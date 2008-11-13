Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKMWwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKMWwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYKMWwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:52:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:30377 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYKMWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sfyQSkSci1RR/csBL0Rufm7Xln8rxt4XIZQhd71IsMhdfZdjSRwzWqDTFK07tEavUK
         yRTO/NNAGZ9EHFodvGXURt+giuLg9BS03If0yihNSX5g0+CsaxEW3IpEBxbPeNvQosFE
         F9oh61pkYXeYV5Wl0+0YqSD1h9ibridhMRHac=
Message-ID: <b6fcc0a0811131452x6531f52dg79845c9f6da1c561@mail.gmail.com>
Date: Fri, 14 Nov 2008 01:52:08 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Subject: Re: [PATCH][RESEND] tracing: fix a build error on alpha
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4906D0AE.7020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4906D0AE.7020903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 11:43 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> +#include <linux/irqflags.h>

Already fixed.
