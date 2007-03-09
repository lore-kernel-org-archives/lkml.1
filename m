Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXCITZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXCITZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933382AbXCITZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:25:52 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60050 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933283AbXCITZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:25:50 -0500
Date: Fri, 9 Mar 2007 11:25:47 -0800
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: ebiederm@xmission.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org, menage@google.com
Subject: Re: [PATCH 1/2] rcfs core patch
Message-Id: <20070309112547.3e82deca.pj@sgi.com>
In-Reply-To: <20070309181422.GB21661@in.ibm.com>
References: <20070301133543.GK15509@in.ibm.com>
	<20070301134528.GL15509@in.ibm.com>
	<m1slcg8m4f.fsf@ebiederm.dsl.xmission.com>
	<20070308101347.GA29051@in.ibm.com>
	<20070309004816.GB4506@MAIL.13thfloor.at>
	<20070309181422.GB21661@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ease of use maybe. Scripts can be more readily used with a fs-based
> interface.

And, as I might have already stated, file system API's are a natural
fit for hierarchically shaped data, especially if the nodes in the
hierarchy would benefit from file system like permission attributes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
