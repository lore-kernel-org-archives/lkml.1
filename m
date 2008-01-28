Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYA1QYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYA1QYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYA1QYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:24:02 -0500
Received: from relay2.sgi.com ([192.48.171.30]:54783 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbYA1QX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:23:59 -0500
Date: Mon, 28 Jan 2008 10:23:57 -0600
From: Paul Jackson <pj@sgi.com>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [RFC] hotplug cpu move tasks in empty cpusets - possible
 refinements
Message-Id: <20080128102357.e6f07139.pj@sgi.com>
In-Reply-To: <20080118152422.7038533B943@attica.americas.sgi.com>
References: <20080118152422.7038533B943@attica.americas.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff wrote:
> I agree with all of the above refinements.
> And I just tested the below patch and find no problem.
> 
> So this is an ACK from me.

I haven't looked, but I doubt this ended up in Andrew's tree.
Note that the Subject above says "RFC", not "PATCH".

Cliff -- could you see what of this, or the other two patches
that I sent in review of your work, made it into Andrew's tree:

  [PATCH 1/3] hotplug cpu move tasks in empty cpusets to parent node_online_map fix
  [PATCH 2/3] hotplug cpu move tasks in empty cpusets to parent various other fixes



-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
