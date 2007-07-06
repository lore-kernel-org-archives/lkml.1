Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbXGFMgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbXGFMgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759868AbXGFMgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:36:08 -0400
Received: from main.gmane.org ([80.91.229.2]:38054 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbXGFMgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:36:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 06 Jul 2007 14:35:53 +0200
Message-ID: <m3zm29pv4m.fsf@ursa.amorsen.dk>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051048.46202.oliver@neukum.org> <1183675095.3388.72.camel@localhost.localdomain> <200707060930.21348.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
Cancel-Lock: sha1:/yAXUqCUqgXhKhaGX1Uvznk3pRg=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "ON" == Oliver Neukum <oliver@neukum.org> writes:

ON> Because we will be unable to escape that job. Let's assume that we
ON> remove the freezer from the STR path. The next complaint would be
ON> that we cannot do STD with fuse. "Then don't do that" would not be
ON> taken kindly as answer.

Ah, we are back to keeping STR broken in order to maybe get STD
working. STR is much more interesting than STD.


/Benny


