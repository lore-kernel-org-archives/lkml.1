Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYBDWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYBDWDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYBDWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:02:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33776 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753718AbYBDWC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:02:56 -0500
Date: Mon, 4 Feb 2008 16:02:54 -0600
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cpw@sgi.com, linux-kernel@vger.kernel.org, clameter@sgi.com,
       rientjes@google.com, menage@google.com, Lee.Schermerhorn@hp.com
Subject: Re: [PATCH 2/4 v2] hotplug cpu move tasks in empty cpusets to
 parent various other fixes
Message-Id: <20080204160254.6c0aa71d.pj@sgi.com>
In-Reply-To: <20080204135606.b6e1a065.akpm@linux-foundation.org>
References: <20080204174051.ACC3F1FE109@attica.americas.sgi.com>
	<20080204135606.b6e1a065.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> I'm going to assume it was Paul.

Yes.

> it (a From: tag) is more reliable than akpm forensics.

Well, I don't know ... akpm forensics are pretty good ;).

But certainly akpm has better uses for his time.

===

Aside to Cliff: I think this means that I should have
suggested that you start these patches with the line:

  From: Paul Jackson <pj@sgi.com>

This From line (or lacking that, the email header From line)
is used to record the author in the source control checkin
record.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
