Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXD0PU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXD0PU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXD0PU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:20:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbXD0PUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:20:21 -0400
Message-ID: <463214AF.2040402@redhat.com>
Date: Fri, 27 Apr 2007 11:20:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.20] system sometimes stops responding
References: <20070423155800.GA20799@vanheusden.com> <20070427114930.GA1021@vanheusden.com>
In-Reply-To: <20070427114930.GA1021@vanheusden.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden wrote:
> Today the problem occured again after 4 days of uptime.
> System not responding to ssh, login on the console and also bind did not seem to respond to anything at all.
> 
> I don't know if it is of any help, but here's the alt+sysreg+m output:

sysrq-t and sysrq-p would be more useful.

