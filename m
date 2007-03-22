Return-Path: <linux-kernel-owner+w=401wt.eu-S934151AbXCVRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbXCVRa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934150AbXCVRa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:30:27 -0400
Received: from saeurebad.de ([85.214.36.134]:44275 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934149AbXCVRaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:30:25 -0400
Date: Thu, 22 Mar 2007 18:29:47 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Dale Blount <linux-kernel@dale.us>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2 and 2.6.20)
Message-ID: <20070322172946.GB5864@localhost>
Mail-Followup-To: Dale Blount <linux-kernel@dale.us>,
	linux-kernel@vger.kernel.org
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk> <loom.20070321T135132-397@post.gmane.org> <20070321190359.GD16768@leiferikson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321190359.GD16768@leiferikson>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 21, 2007 at 08:04:00PM +0100, Johannes Weiner wrote:
> Did I even get the right place on where the NULL pointer dereference
> happens? :)

No, I did not. Sorry for the noise.

=Hannes
