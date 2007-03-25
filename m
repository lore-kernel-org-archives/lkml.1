Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXCYE7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXCYE7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXCYE7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:59:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58707 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933082AbXCYE7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:59:18 -0400
Date: Sat, 24 Mar 2007 21:59:16 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container
 system abstracted from cpusets code
Message-Id: <20070324215916.ecb0c5a2.pj@sgi.com>
In-Reply-To: <20070325050507.GG11794@in.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212085104.130746000@menage.corp.google.com>
	<20070324150505.GB9475@in.ibm.com>
	<20070324122559.11b9ba34.pj@sgi.com>
	<20070325004529.GD11794@in.ibm.com>
	<20070324184128.e8b34a3e.pj@sgi.com>
	<20070325022816.GE11794@in.ibm.com>
	<20070324214550.d6e654bf.pj@sgi.com>
	<20070325050507.GG11794@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I will try to send out a patch later today to fix

Thanks!

> Agreed, but good to keep code clean isn't it? :)

Definitely.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
