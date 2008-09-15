Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYIOJEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYIOJEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 05:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYIOJDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 05:03:54 -0400
Received: from yorgi.telenet-ops.be ([195.130.133.69]:58405 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYIOJDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 05:03:53 -0400
Date: Mon, 15 Sep 2008 11:03:20 +0200
From: Frederik Himpe <fhimpe@telenet.be>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-xfs@oss.sgi.com
Subject: Re: XFS does not recognise mount options in 2.6.27-rc6
Message-ID: <20080915090320.GA19851@telenet.be>
References: <pan.2008.09.14.18.53.20@telenet.be> <200809150231.01220.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809150231.01220.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 02:31:00AM +0200, Rafael J. Wysocki wrote:
> On Sunday, 14 of September 2008, Frederik Himpe wrote:
> > In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
> > others. Because of this, at boot time it fails to mount the partitions rw, 
> > making the system unusable.
> 
> Was 2.6.26 OK?

Yes, with 2.6.26 it mounts fine. According to that earlier message on
the list, this is a regression introduced in either 2.6.27-rc2 or
2.6.27-rc3.

-- 
Frederik Himpe
