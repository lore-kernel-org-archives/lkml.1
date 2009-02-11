Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZBKMRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZBKMRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZBKMRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:17:22 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46916 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZBKMRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:17:21 -0500
Date: Wed, 11 Feb 2009 13:17:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
In-Reply-To: <20090211014506.GA5075@srcf.ucam.org>
Message-ID: <alpine.LRH.1.10.0902111315360.22097@twin.jikos.cz>
References: <20090204191540.2d6abd87@infradead.org> <20090211014506.GA5075@srcf.ucam.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009, Matthew Garrett wrote:

> https://lists.ubuntu.com/archives/kernel-team/2009-February/004335.html 
> be related? It seems quite plausible that we want to do this on all 
> hardware.

Actually I have also hit this on several machines. Dmitry, I would propose 
to take Andy's patch (maybe even for 2.6.29?), it would save us a lot of 
bugreports in the future.

-- 
Jiri Kosina
SUSE Labs

