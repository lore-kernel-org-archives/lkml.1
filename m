Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbZFXQkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbZFXQkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760968AbZFXQjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:39:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740AbZFXQjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:39:46 -0400
Date: Wed, 24 Jun 2009 09:34:56 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de
Subject: Re: [PATCH 2/2] UIO: remove 'default n' from Kconfig
Message-ID: <20090624163456.GC26409@suse.de>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de> <1245857425-25389-2-git-send-email-daniel@caiaq.de> <1245857425-25389-3-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245857425-25389-3-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 05:30:25PM +0200, Daniel Mack wrote:
> 'default n' is the default, there is no need for these lines.

Why, because 'n' is the generic default?
If so, it really can't hurt, right?  :)

thanks,

greg k-h
