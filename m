Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbYHFPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbYHFPxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbYHFPsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:48:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42340 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbYHFPsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:48:14 -0400
Subject: Re: RFC: I/O bandwidth controller
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, xen-devel@lists.xensource.com,
       uchida@ap.jp.nec.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@sourceware.org,
       virtualization@lists.linux-foundation.org, ngupta@google.com,
       righi.andrea@gmail.com
In-Reply-To: <1218004892.3950.12.camel@sebastian.kern.oss.ntt.co.jp>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz>
	 <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080806.151824.104049463.ryov@valinux.co.jp>
	 <1218004892.3950.12.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 06 Aug 2008 08:48:08 -0700
Message-Id: <1218037688.10907.85.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 15:41 +0900, Fernando Luis Vázquez Cao wrote:
> > I agree with your plan.
> > We keep bio-cgroup improving and porting to the latest kernel.
> Having more users of bio-cgroup would probably help to get it merged, so
> we'll certainly send patches as soon as we get our cfq prototype in
> shape.

I'm confused.  Are these two of the competing controllers?  Or are the
complementary in some way?

-- Dave

