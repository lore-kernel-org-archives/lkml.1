Return-Path: <linux-kernel-owner+w=401wt.eu-S934806AbYCFCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806AbYCFCfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934302AbYCFC36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:29:58 -0500
Received: from mail.lang.hm ([64.81.33.126]:40237 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934471AbYCFC35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:29:57 -0500
Date: Wed, 5 Mar 2008 18:31:00 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: phillips@phunq.net
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] An alternative interface to device mapper 
Message-ID: <alpine.DEB.1.00.0803051830290.14137@asgard.lang.hm>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgive the lack of threading, I missed this yesterday and just found this via 
the LWN article.

I like the general approach that you are taking of simplifying the interface, 
however in your interest of making it easy to write C code for you are making 
the new interface difficult to script for. is it really that painful to to make 
everything file based so that it can be scripted as well?

frankly, most sysadmins do a lot of scripting and almost no C coding, so while 
a nice C interface is useful for creating tools, a good scripting interface is 
critical for good, flexible use by sysadmins.

David Lang
