Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZLJCtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZLJCtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbZLJCtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:49:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbZLJCtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:49:12 -0500
Date: Wed, 9 Dec 2009 18:49:01 -0800
From: Greg KH <gregkh@suse.de>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, Artem.Bityutskiy@nokia.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] device class: add symlink creation helpers
Message-ID: <20091210024901.GC20410@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <30f1f2c867089bb78cdb9fe3c2032c091bed106a.1260364108.git.ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f1f2c867089bb78cdb9fe3c2032c091bed106a.1260364108.git.ext-jani.1.nikula@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 03:49:02PM +0200, Jani Nikula wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

No, I don't like this, we do not want to be creating symlinks in a class
directory.  See my other email about this.

thanks,

greg k-h
