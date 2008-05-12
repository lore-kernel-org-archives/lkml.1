Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYELPYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYELPYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYELPYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:24:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYELPYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:24:00 -0400
Date: Mon, 12 May 2008 10:23:21 -0500
From: David Teigland <teigland@redhat.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] DLM: Convert connections_lock in a mutex
Message-ID: <20080512152321.GC31873@redhat.com>
References: <20080506203354.GB27656@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506203354.GB27656@traven>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 10:33:54PM +0200, Matthias Kaehlcke wrote:
> Distributed Lock Manager: The semaphore connections_lock is used as a
> mutex. Convert it to the mutex API.
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Thanks, I've added this to dlm.git, along with the followup #include
from Andrew.

Dave

