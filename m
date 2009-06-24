Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZFXScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZFXScU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZFXScN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:32:13 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47641 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZFXScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:32:13 -0400
Date: Wed, 24 Jun 2009 20:32:12 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de
Subject: Re: [PATCH 2/2] UIO: remove 'default n' from Kconfig
Message-ID: <20090624183212.GZ29236@buzzloop.caiaq.de>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de> <1245857425-25389-2-git-send-email-daniel@caiaq.de> <1245857425-25389-3-git-send-email-daniel@caiaq.de> <20090624163456.GC26409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624163456.GC26409@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:34:56AM -0700, Greg KH wrote:
> On Wed, Jun 24, 2009 at 05:30:25PM +0200, Daniel Mack wrote:
> > 'default n' is the default, there is no need for these lines.
> 
> Why, because 'n' is the generic default?
> If so, it really can't hurt, right?  :)

Well, it's a cleanup. In it's purest manner. :)

Daniel

