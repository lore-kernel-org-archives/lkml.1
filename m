Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYDXSat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYDXSat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYDXSag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:30:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37087 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbYDXSaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:30:35 -0400
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object
	creation with a specified id)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Kirill Korotaev <dev@parallels.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <48103002.5090806@parallels.com>
References: <20080418054459.891481000@bull.net>
	 <20080422193612.GA15835@martell.zuzino.mipt.ru>
	 <1208890580.17117.14.camel@nimitz.home.sr71.net>
	 <20080422210130.GA15937@martell.zuzino.mipt.ru>
	 <1208904967.17117.51.camel@nimitz.home.sr71.net>
	 <480ED9D5.1010906@parallels.com>
	 <1208964798.17117.72.camel@nimitz.home.sr71.net>
	 <48103002.5090806@parallels.com>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 11:30:09 -0700
Message-Id: <1209061809.12718.36.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 11:00 +0400, Kirill Korotaev wrote:
> Yeah... we talked with Andrew yesterday. He mostly agrees with a black
> box.
> He also said an interesting idea, that if you need compatibility
> between the kernels (like we for example, support for migration from
> 2.6.9 to 2.6.18 in OpenVZ)
> you can do image conversion in user-space...

That sounds compelling to me.  I'm definitely willing to explore it.

Any thoughts on what we should start with?  What can we get merged, most
easily?

-- Dave

