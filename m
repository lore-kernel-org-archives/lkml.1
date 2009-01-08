Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZAHH5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZAHH5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZAHH5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:57:24 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36875 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZAHH5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:57:23 -0500
Date: Thu, 8 Jan 2009 08:59:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Spaces in filenames in gen_initramfs_list.sh/gen_init_cpio.c?
Message-ID: <20090108075901.GB14179@uranus.ravnborg.org>
References: <200901071656.18802.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901071656.18802.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 04:56:18PM -0600, Rob Landley wrote:
> What do I do if I have a space in a filename that I want to put into an 
> initramfs?  (Or a space in the source argument of "file" entries or the 
> redirect argument of "slink" entries?)
> 
> I don't see any kind of quoting or escape syntax, has anybody planned one or 
> should I go write something myself?

I have not seen anything addressing this - please go ahead.

	Sam
