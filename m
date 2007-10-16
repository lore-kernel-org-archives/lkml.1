Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbXJPAFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbXJPAFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXJPAEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:04:55 -0400
Received: from ozlabs.org ([203.10.76.45]:40028 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbXJPAEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:04:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC 2/2] paravirt: clean up lazy mode handling
Date: Tue, 16 Oct 2007 10:04:42 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
References: <470FDBC4.4050306@goop.org>
In-Reply-To: <470FDBC4.4050306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161004.43338.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007 06:40:36 Jeremy Fitzhardinge wrote:
> [ Changes since last post: fixed up lguest ]

This is really nice.  Thanks Jeremy!

This will conflict a little with my own churn (file movement), but no great 
drama if it goes in soon.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
