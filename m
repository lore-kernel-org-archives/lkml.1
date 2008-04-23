Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYDWPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYDWPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYDWPd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:33:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33301 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYDWPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:33:26 -0400
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object
	creation with a specified id)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Kirill Korotaev <dev@parallels.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <480ED9D5.1010906@parallels.com>
References: <20080418054459.891481000@bull.net>
	 <20080422193612.GA15835@martell.zuzino.mipt.ru>
	 <1208890580.17117.14.camel@nimitz.home.sr71.net>
	 <20080422210130.GA15937@martell.zuzino.mipt.ru>
	 <1208904967.17117.51.camel@nimitz.home.sr71.net>
	 <480ED9D5.1010906@parallels.com>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 08:33:18 -0700
Message-Id: <1208964798.17117.72.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 10:40 +0400, Kirill Korotaev wrote:
> Having all this functionality in a signle syscall we specifically CLAIM a black box,
> and that no one can use this interfaces for something different from checkpoint/restore.
> 
> So I think we have to know what other maintainers think before we can go.

I completely agree.

Have you asked any particular maintainers what they think?

-- Dave

