Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbZDAWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbZDAWQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbZDAWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:16:28 -0400
Received: from baikonur.stro.at ([213.239.196.228]:48466 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbZDAWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:16:27 -0400
Date: Wed, 1 Apr 2009 23:44:34 +0200
From: maximilian attems <max@stro.at>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 4/5] deb-pkg: allow to specify a custom revision for
	.deb packages
Message-ID: <20090401214434.GE17518@stro.at>
References: <200904012143.36217.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012143.36217.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009, Frans Pop wrote:

> Allow to specify a custom revision for the generated .deb by
> exporting the environment variable KDEB_PKGVERSION.
> 
nack
looks like double work circumventling .localversion
