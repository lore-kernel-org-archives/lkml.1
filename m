Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbXGFB3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbXGFB3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760460AbXGFB3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:29:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36447 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758688AbXGFB3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:29:03 -0400
Date: Thu, 5 Jul 2007 18:28:57 -0700
From: Paul Jackson <pj@sgi.com>
To: Adrian Bunk <bunk@stusta.de>, Paul Menage <menage@google.com>
Cc: simon.derr@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/cpuset.c: cleanups
Message-Id: <20070705182857.20be062d.pj@sgi.com>
In-Reply-To: <20070705232311.GZ3492@stusta.de>
References: <20070705232311.GZ3492@stusta.de>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - make the following needlessly global functions static:

Ok by me, but this is really the patches of Paul Menage <menage@google.com>,
in particular:

  containersv10-make-cpusets-a-client-of-containers.patch

that you dealing with -- adding him to the cc list.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
