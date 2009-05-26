Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZEZUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZEZUex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZEZUeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:34:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbZEZUep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:34:45 -0400
Date: Tue, 26 May 2009 12:38:19 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging: rtl8192su: remove dos style EOL
Message-ID: <20090526193819.GA12315@suse.de>
References: <20090526154747.GA14893@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526154747.GA14893@orion>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 07:47:47PM +0400, Alexander Beregalov wrote:
> Hi Greg,
> 
> Could you please run dos2unix on patch which adds
> drivers/staging/rtl8192su before it will be in Linus's git.

Ick, sorry about that, for some reason my scripts missed this.

I'll go do that right now, thanks for pointing it out to me.

greg k-h
