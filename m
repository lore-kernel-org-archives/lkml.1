Return-Path: <linux-kernel-owner+w=401wt.eu-S935822AbZAOW5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822AbZAOW5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935826AbZAOWec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:34:32 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1559 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbZAOWea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:34:30 -0500
Subject: Re: [XFS] Update maintainers
From: Joe Perches <joe@perches.com>
To: "Bill O'Donnell" <billodo@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200901150459.n0F4xhVS016322@hera.kernel.org>
References: <200901150459.n0F4xhVS016322@hera.kernel.org>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 14:35:36 -0800
Message-Id: <1232058936.3109.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 04:59 +0000, Linux Kernel Mailing List wrote:
>     [XFS] Update maintainers
>     New maintainer contact and new tree location.
> ---
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a018844..5f74bce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4824,11 +4824,11 @@ S:	Supported
>  
>  XFS FILESYSTEM
>  P:	Silicon Graphics Inc
> -P:	Tim Shimmin
> +P:	Bill O'Donnell
>  M:	xfs-masters@oss.sgi.com
>  L:	xfs@oss.sgi.com
>  W:	http://oss.sgi.com/projects/xfs
> -T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
> +T:	git://oss.sgi.com/xfs/xfs.git
>  S:	Supported

Should your email address appear here?  Perhaps:

XFS FILESYSTEM
P:	Bill O'Donnell
M:	billodo@sgi.com
P:	Silicon Graphics Inc
M:	xfs-masters@oss.sgi.com
L:	xfs@oss.sgi.com
W:	http://oss.sgi.com/projects/xfs
T:	git://oss.sgi.com/xfs/xfs.git
S:	Supported


