Return-Path: <linux-kernel-owner+w=401wt.eu-S934755AbZDAVm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934755AbZDAVm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbZDAVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:42:45 -0400
Received: from baikonur.stro.at ([213.239.196.228]:36278 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbZDAVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:42:45 -0400
Date: Wed, 1 Apr 2009 23:43:19 +0200
From: maximilian attems <max@stro.at>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5b/5] deb-pkg: allow alternative hook scripts directory
	in .deb packages
Message-ID: <20090401214319.GD17518@stro.at>
References: <200904012133.37387.elendil@planet.nl> <200904012144.13077.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012144.13077.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009, Frans Pop wrote:

> Hook scripts in the default directory /etc/kernel are also executed by
> official Debian kernel packages as well as kernel packages created using
> make-kpkg. Allow to specify the base hook scripts directory in the kernel
> configuration (DEB_HOOKDIRS_PATH).

this seems overkill defer to discussions.
