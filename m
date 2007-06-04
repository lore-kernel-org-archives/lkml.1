Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbXFDVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbXFDVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXFDVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:16:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47127 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbXFDVQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:16:21 -0400
Date: Mon, 4 Jun 2007 14:16:17 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, serue@us.ibm.com, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-Id: <20070604141617.720942d5.pj@sgi.com>
In-Reply-To: <20070604211103.GA15923@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com>
	<20070604205106.GA31530@sergelap.austin.ibm.com>
	<6599ad830706041356r5a031dd5w2eeb3ff4c7c64b72@mail.gmail.com>
	<20070604211103.GA15923@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge wrote:
> Odd, I thought rm -rf used to work in the past,
> but i'm likely wrong.

I'm pretty sure it never worked.

And I've probably tested it myself, every few months,
since the birth of cpusets, when I forget and type it
again, and then stare dumbly at the screen wondering
what all the complaining is about.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
