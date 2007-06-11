Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXFKPkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXFKPkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbXFKPki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:40:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:46539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbXFKPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=m56fVZftPRnwBY3UeIAplH/eTnuSG6xe/0maijpf6Ju1jVuB2dUfiN+Uv40P//I0Irwac0iHCU2OCoBBEg+F0ds8LFOneNZwEm4rjedS3J6CODX5lSilHPajlQA1bXEvF0l3D0L9iB8Koykn70VVPDB+/9jAw+rO/xQTzzl8XKo=
Date: Mon, 11 Jun 2007 19:46:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: API changes / 2.6.21 sysctl changes
Message-ID: <20070611154627.GA5715@martell.zuzino.mipt.ru>
References: <200706111513.12998.bernd-schubert@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706111513.12998.bernd-schubert@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 03:13:12PM +0200, Bernd Schubert wrote:
> in 2.6.21 register_sysctl_table(), struct ctl_table and probably something
> else did change. Unfortunately so far I didn't figure out the "something
> else".

Do you have a problem porting your sysctls to newer kernels?

