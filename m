Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYGYWoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYGYWoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYGYWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:44:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:43494 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYGYWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F3LxaE4KTOAJJcbt8+v9L8DsOUVSTgDqxFDp4a06A9STlNHz4EiXsN2qb7DdI6bJD2
         fTfPHL/2sxG+ZRXGjCKtRUyUjRJxzPl0LHqXnIv/c87DloIhWwxAw69CXz2BhEzQdtzJ
         ek48Y2pVdqY2j5IKQp9q7TIoalnRp+wUbFuU4=
Date: Sat, 26 Jul 2008 02:44:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric ROMMELFANGEN <eric.rommelfangen@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [>=2.6.26-git9]general protection fault in PREEMPT SMP when
	downloading
Message-ID: <20080725224410.GA5345@martell.zuzino.mipt.ru>
References: <488A4FB4.8090602@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488A4FB4.8090602@numericable.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 12:12:04AM +0200, Eric ROMMELFANGEN wrote:
> Since 2.6.26-git9 kernel, I have this protection fault when downloading 
> files with ftp or http protocol :
> ...
> trying to fetch "http:www..."
> general protection fault : 0000 [1] PREEMPT SMP
> CPU1
> Modules linked in: iptables_raw xt_comment xt_policy ipt_ULOG ipt_TTL ...
>
> I attach my .config.
>
> Could someone tells me what the matter with this error ?

No, unless you post full protection fault message not just start of it.

