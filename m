Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbYGQTgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbYGQTgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760314AbYGQTdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:33:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:53739 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbYGQTdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vSwkjq5m/KjQpKQhDCzLDieU9Qji65npJ/V5OoxAO9a4YzpE2tvK+gZadr0enh5gZE
         xcbSVvgDr6Qhs63cHf3aVTzwhvST7GNRfR42H6PzH55SxhVGK0JIrSiIrP94T85O5mtk
         Uxchl1hdDfv+3r4gU9+I6viEunPeMVFX8bqxw=
Date: Thu, 17 Jul 2008 23:30:24 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
Message-ID: <20080717193024.GA17916@martell.zuzino.mipt.ru>
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 09:13:55PM +0200, Fred . wrote:
> Previously we have not been able to have ZFS support due to it being
> licensed under the CDDL and the kernel under the GPL.

Wrong. License is the last of your problems.

> Sun have contributed ZFS support to GRUB under the GPL license.

Only read-only.

> We could now use that code to implement support for ZFS in the Linux
> kernel.
> 
> http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists

And I have some sketches. Not yet ready to send anywhere.

