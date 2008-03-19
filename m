Return-Path: <linux-kernel-owner+w=401wt.eu-S940308AbYCSWR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940308AbYCSWR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762386AbYCSUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:50:07 -0400
Received: from phunq.net ([64.81.85.152]:57177 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762394AbYCSUuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:50:05 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [ANNOUNCE] ddtree: A git kernel tree for storage servers
Date: Wed, 19 Mar 2008 12:50:01 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803190102.25491.phillips@phunq.net> <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
In-Reply-To: <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803191350.02024.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2008 13:23, Mike Snitzer wrote:
> >   * Block layer deadlock fixes (Status: production)
> 
> Do you happen to have a pointer to where these block layer deadlock
> fixes are?  Or will you be committing them shortly?

Hi Mike,

Committing shortly.  They also live here:

   http://code.google.com/p/zumastor/source/browse/trunk/ddsnap/patches/2.6.24.2/bio.throttle.patch
   ...etc...

Regards,

Daniel
