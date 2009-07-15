Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZGOJqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZGOJqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZGOJqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:46:10 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:48722 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753676AbZGOJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:46:10 -0400
X-Sender-Authentication: net64
Date: Wed, 15 Jul 2009 11:46:05 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: David Rientjes <rientjes@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: What to do with this message (2.6.30.1) ?
Message-Id: <20090715114605.42a354c0.skraw@ithnet.com>
In-Reply-To: <alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
References: <20090713134621.124aa18e.skraw@ithnet.com>
	<4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
	<alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com>
	<20090715084754.36ff73bf.skraw@ithnet.com>
	<alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 01:18:02 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:


> [slabtop -o]

Ok, so I just found out that slabtop -o outputs a lot of ANSI code by
redirecting it, that output is merely unreadable. Can some kind soul please
tell the author that formatting ANSI output in -o option makes no sense at
all. top btw does not do this (top -b -n 1).
I will produce your logs, but you will have a hard time reading that trash ...

-- 
Regards,
Stephan
