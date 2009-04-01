Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbZDAVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbZDAVmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZDAVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:41:59 -0400
Received: from baikonur.stro.at ([213.239.196.228]:36259 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZDAVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:41:58 -0400
Date: Wed, 1 Apr 2009 23:42:34 +0200
From: maximilian attems <max@stro.at>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5a/5] deb-pkg: allow alternative hook scripts directory
	in .deb packages
Message-ID: <20090401214234.GC17518@stro.at>
References: <200904012133.37387.elendil@planet.nl> <200904012143.52853.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012143.52853.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009, Frans Pop wrote:

> Hook scripts in the default directory /etc/kernel are also executed by
> official Debian kernel packages as well as kernel packages created using
> make-kpkg. Allow to specify an alternative hook scripts directory by
> exporting the environment variable KDEB_HOOKDIR.

under discusisson, no ack yet.
