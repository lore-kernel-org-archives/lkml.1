Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbXF0LW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbXF0LW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXF0LWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:22:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbXF0LWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:22:19 -0400
Date: Wed, 27 Jun 2007 13:22:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070627112216.GA31708@one.firstfloor.org>
References: <200706251434.43863.jesse.barnes@intel.com> <46823F71.6060200@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46823F71.6060200@macroscoop.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 12:44:01PM +0200, Pim Zandbergen wrote:
> Jesse saved my life by releasing a patch that made my GigaByte Intel G33
> based motherboard use all of its 8GB RAM and not be slow as hell.

That's impossible. Either it limited your RAM or it didn't change anything.

-Andi
