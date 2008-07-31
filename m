Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYGaUD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYGaUD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGaUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:03:17 -0400
Received: from namei.org ([69.55.235.186]:33611 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597AbYGaUDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:03:17 -0400
Date: Fri, 1 Aug 2008 06:02:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
In-Reply-To: <200807310909.27619.gene.heskett@gmail.com>
Message-ID: <Xine.LNX.4.64.0808010559290.30244@us.intercode.com.au>
References: <200807302254.26036.gene.heskett@gmail.com>
 <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au>
 <200807310909.27619.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Gene Heskett wrote:

> >Which new options?
> 
> Make xconfig-->security options:
> 
> XFRM Networking security hooks
> 
>  and several others just below it.  Unforch, I can't copy/paste the screen.  

I can't really imagine what that is (although if you enable the secmark 
controls under the main SELinux menu, which are disabled by default, 
there could be problems).

Please post your .config.



- James
-- 
James Morris
<jmorris@namei.org>
