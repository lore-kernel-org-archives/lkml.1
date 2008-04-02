Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYDBFbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYDBFbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 01:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYDBFbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 01:31:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52853 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750740AbYDBFbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 01:31:32 -0400
Date: Wed, 2 Apr 2008 00:31:27 -0500
From: Paul Jackson <pj@sgi.com>
To: Vasily Tarasov <vtaras@openvz.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, devel@openvz.org,
       containers@linux-foundation.com, dev@openvz.org, xemul@openvz.org,
       vtaras@openvz.org
Subject: Re: [RFC][PATCH 0/9] cgroups: block: cfq: I/O bandwidth controlling
 subsystem for CGroups based on CFQ
Message-Id: <20080402003127.d22e9d3e.pj@sgi.com>
In-Reply-To: <1203058414.042372.2088.nullmailer@me>
References: <1203058414.042372.2088.nullmailer@me>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of details:
 1) Your clock is way off.  These patches have a date stamp of Feb 15,
    but were actually sent out March 21 (and I'm behind in my reading of
    lkml - sorry ;).
 2) Please put a different Subject on each path ... not just the N/M
    patch number, but use different words to describe each patch.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
