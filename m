Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZKCMMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZKCMMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZKCMM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:12:29 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:43956 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZKCMM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:12:29 -0500
Date: Tue, 3 Nov 2009 13:12:20 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CRIS v32: Should index be positive?
Message-ID: <20091103121219.GG13605@axis.com>
References: <4AED9132.2060507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AED9132.2060507@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 02:46:26PM +0100, Roel Kluin wrote:
> `port' is used as index for writing to pins during
> allocation/deallocation. It should be positive.

Yup, that's correct. I've added this to the CRIS tree.
Thanks!

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
