Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZKVVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZKVVho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 16:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZKVVho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 16:37:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44998 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbZKVVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 16:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8IYaowTqvmFYZgBS7osaAH9heF3dLThBm6Wv4hHGBHVZMu7PWD+/4dUrEhgA3UweL
         Ds4dZwBWN1GenzM4uOoeOE7pcTBcd8azlPIkoEF9gzkkCU+HJzg/n7SFOnqxXIzeoaOl
         46m4GP8GeRa74rOb84Z73zaPO8q6xJbV1y6mw=
Date: Mon, 23 Nov 2009 08:37:42 +1100
From: Robert Swan <swan.r.l@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122213742.GA3948@swanrl.gmail.com>
Reply-To: swan.r.l@gmail.com
References: <20091121222319.GA3905@swanrl.gmail.com> <20091121232320.3262636c@lxorguk.ukuu.org.uk> <20091122002748.GA6605@swanrl.gmail.com> <20091122122942.644006fb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122122942.644006fb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 12:29:42PM +0000, Alan Cox wrote:
> not when the CPU is idle. That wants changing and it strikes me as utterly
> dumb in general to be deferring work when the CPU is idle.

That's how it struck me.

Rob.
