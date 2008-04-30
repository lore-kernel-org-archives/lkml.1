Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbYD3ITO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbYD3ITO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYD3ITB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:19:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32848 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755559AbYD3ITA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:19:00 -0400
Date: Wed, 30 Apr 2008 03:18:57 -0500
From: Paul Jackson <pj@sgi.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       clg@fr.ibm.com, pavel@ucw.cz, menage@google.com,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org
Subject: Re: [RFC][PATCH 5/5] Add a Signal Control Group Subsystem
Message-Id: <20080430031857.cda5d105.pj@sgi.com>
In-Reply-To: <1209541714.6095.72.camel@localhost.localdomain>
References: <20080424064756.643890130@us.ibm.com>
	<20080424064758.113999091@us.ibm.com>
	<20080424143032.7e659522.pj@sgi.com>
	<1209541714.6095.72.camel@localhost.localdomain>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt wrote:
> OK, I renamed it signal.send

I'm not familiar with the cgroup subsystem naming conventions,
but modulo that, this looks good to me - thanks!

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
