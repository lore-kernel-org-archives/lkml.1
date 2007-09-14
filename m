Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbXINRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbXINRtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXINRtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:49:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40035 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbXINRtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:49:07 -0400
Date: Fri, 14 Sep 2007 19:50:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Trace code and documentation
Message-ID: <20070914175027.GA3642@uranus.ravnborg.org>
References: <46E9CB14.7060000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E9CB14.7060000@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

A random comment to the code.
Several of the struct file_operations are not declared static as
they should be.

Btw. it looks good from a coding style point-of-view.

About the name what about ktrace??

	Sam
