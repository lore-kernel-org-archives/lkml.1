Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbXF0REF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbXF0REF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761947AbXF0RDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:03:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761856AbXF0RDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:03:49 -0400
Date: Wed, 27 Jun 2007 10:03:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net, ldm@flatcap.org
Subject: Re: [2.6 PATCH] Fix LDM for new field in the VOL5 VBLK.
In-Reply-To: <Pine.LNX.4.64.0706271138220.18280@hermes-1.csi.cam.ac.uk>
Message-ID: <alpine.LFD.0.98.0706271001070.8675@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706271138220.18280@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Anton Altaparmakov wrote:
> 
> Please apply the below patch to the LDM driver. 

This looks fine, but last time I applied a LDM patch just before release, 
there was some embarrassing compile problem with it.

See commit 72dd9ca59944.

Which just makes me go "hmm.." at this stage.

		Linus
