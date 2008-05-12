Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYELPs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYELPs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYELPsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:48:46 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:53187 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYELPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:48:45 -0400
Date: Mon, 12 May 2008 08:48:44 -0700 (PDT)
From: Dave Olson <dave.olson@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
cc: Pavel Emelyanov <xemul@openvz.org>, infinipath@qlogic.com,
       ralph.campbell@qlogic.com, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       John Gregor <john.gregor@qlogic.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][INFINIBAND]: Make ipath_portdata work with struct pid
 * not pid_t.
In-Reply-To: <adave1jo7hd.fsf@cisco.com>
Message-ID: <alpine.LFD.1.00.0805120847410.1536@topaz.pathscale.com>
References: <482857AE.2030904@openvz.org> <adave1jo7hd.fsf@cisco.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 12 May 2008 15:48:41.0956 (UTC) FILETIME=[A71EF240:01C8B447]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008, Roland Dreier wrote:

| Seems fine to me... ipath guys, any comment?  I think it would be
| reasonale to include this with the other ipath fixes when I ask Linus to
| pull in a day or two.

I looked at the original patch, and it looks fine to me.

Should be fairly easy to cover in ofed 1.4 backport patches for the
older kernels.

Dave Olson
dave.olson@qlogic.com
