Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAXXdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAXXdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYAXXdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:33:15 -0500
Received: from zakalwe.fi ([80.83.5.154]:42110 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYAXXdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:33:14 -0500
Date: Fri, 25 Jan 2008 01:33:13 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header file
Message-ID: <20080124233313.GD12172@zakalwe.fi>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <47991B7C.6000208@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 02:13:00AM +0300, Dmitri Vorobiev wrote:
> Care to explain why?

Because functions are always external objects in C. I just verified that 
from K&R.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
