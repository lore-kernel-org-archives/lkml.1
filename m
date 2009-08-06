Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZHFOA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZHFOA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZHFOA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:00:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbZHFOAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:00:25 -0400
Date: Thu, 6 Aug 2009 16:59:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Avi Kivity <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
Message-ID: <20090806135903.GA11530@redhat.com>
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com> <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com> <4A7AD29E.50800@redhat.com> <4A7A9C6B0200005A00051BB9@sinclair.provo.novell.com> <4A7ADE23.5010208@redhat.com> <4A7AA63A0200005A00051BE2@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AA63A0200005A00051BE2@sinclair.provo.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 07:45:30AM -0600, Gregory Haskins wrote:
> > (though still rooting for virtio).
> 
> Heh...not to belabor the point to death, but virtio is orthogonal (you keep forgetting that ;).

venet and virtio aren't orthogonal, are they?

-- 
MST
