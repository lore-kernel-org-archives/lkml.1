Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYGUMii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYGUMii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYGUMia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:38:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYGUMi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:38:29 -0400
Date: Mon, 21 Jul 2008 08:37:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Haren Myneni <hbabu@us.ibm.com>
Subject: Re: [PATCH] kdump: Update kdump documentation as
	kexec-tools-resting has been renamed kexec-tools
Message-ID: <20080721123706.GA4451@redhat.com>
References: <20080719005835.GA19032@verge.net.au> <20080719011612.GA20745@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719011612.GA20745@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 11:16:14AM +1000, Simon Horman wrote:
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> --- 
> Reposting to Vivek's new email address
> 
> Index: linux-2.6/Documentation/kdump/kdump.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kdump/kdump.txt	2008-07-19 10:27:50.000000000 +1000
> +++ linux-2.6/Documentation/kdump/kdump.txt	2008-07-19 10:51:57.000000000 +1000
> @@ -65,26 +65,26 @@ Install kexec-tools
>  
>  2) Download the kexec-tools user-space package from the following URL:
>  
> -http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing.tar.gz
> +http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
>  
> -This is a symlink to the latest version, which at the time of writing is
> -20061214, the only release of kexec-tools-testing so far. As other versions
> -are released, the older ones will remain available at
> -http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
> +This is a symlink to the latest version.
>  
> -Note: Latest kexec-tools-testing git tree is available at
> +The latest kexec-tools git tree is available at:
>  
> -git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools-testing.git
> +git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools.git
>  or
> -http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=summary
> +http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
> +
> +More information about kexec-tools can be found at
> +http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
>  
>  3) Unpack the tarball with the tar command, as follows:
>  
> -   tar xvpzf kexec-tools-testing.tar.gz
> +   tar xvpzf kexec-tools.tar.gz
>  
>  4) Change to the kexec-tools directory, as follows:
>  
> -   cd kexec-tools-testing-VERSION
> +   cd kexec-tools-VERSION
>  
>  5) Configure the package, as follows:

Looks Good. Thanks Simon.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
