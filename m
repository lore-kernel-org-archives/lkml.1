Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbXGSVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbXGSVyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXGSVym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:54:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXGSVyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:54:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Fri, 20 Jul 2007 00:02:14 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191459.20998.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD628550DD6@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628550DD6@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200002.14959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 19 July 2007 23:06, Agarwal, Lomesh wrote:
> So basically I can not install a signal handler to catch freeze signal
> in the process. Right?
> Is there any other way to solve the problem I am facing? After resume
> some of the system calls are failing in some of my applications with
> errno set as EINTR. I wanted to explore a way to not check for this
> error all over the place and somehow retry failed system call. Any
> ideas?

Can you please tell us what exactly these applications do?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
