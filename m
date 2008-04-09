Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYDIPOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYDIPOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYDIPOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:14:16 -0400
Received: from xenotime.net ([66.160.160.81]:50546 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753330AbYDIPOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:14:15 -0400
Date: Wed, 9 Apr 2008 08:14:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-Id: <20080409081412.5d2a5596.rdunlap@xenotime.net>
In-Reply-To: <20080409131420.GL17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
	<20080408171257.GF17915@shadowen.org>
	<87ej9gp6ol.fsf@basil.nowhere.org>
	<20080409081943.GI17915@shadowen.org>
	<20080409083013.GJ17915@shadowen.org>
	<20080409084606.GD19010@one.firstfloor.org>
	<20080409131420.GL17915@shadowen.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008 14:14:20 +0100 Andy Whitcroft wrote:

> === 8< ===
> add a note on the risks associated with wide ranging style cleanups
> 
> Add a NOTE to the SubmittingPatches guide pointing out the issues which
> may occur when submitting wide ranging style cleanups, and pointing the
> reader to the area maintainers.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
>  Documentation/SubmittingPatches |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 08a1ed1..633b9cf 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -472,6 +472,12 @@ The checker reports at three levels:
>  You should be able to justify all violations that remain in your
>  patch.
>  
> +NOTE: updating entire files purely for style violations can cause
> +significant issues for other contributers and maintainers by increasing

                                contributors

> +collisions between patches.  It is therefore recommended you contact the
> +area Maintainer to ensure these patches are likely to be accepted _before_
> +starting work.
> +
>  
>  
>  2) #ifdefs are ugly



---
~Randy
