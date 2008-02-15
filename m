Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYBOMpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYBOMpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761477AbYBOMpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:45:03 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45779 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763599AbYBOMpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:45:01 -0500
Date: Fri, 15 Feb 2008 13:45:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: allow to specify a custom revision for .deb packages
Message-ID: <20080215124509.GA1178@uranus.ravnborg.org>
References: <200802131118.11413.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802131118.11413.elendil@planet.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:18:11AM +0100, Frans Pop wrote:
> From: Frans Pop <elendil@planet.nl>
> 
> Allow to specify a custom revision for the generated .deb package
> by exporting the environment variable KERNELDEBREVISION.

If this is needed I think we need such functionality
across all package targets.
So please try to come up with a solution that would
fit rpm as well as deb.

	Sam
