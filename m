Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYJXW4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYJXW4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYJXW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:56:34 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:33401 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYJXW4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:56:33 -0400
Message-ID: <49025275.4050102@nortel.com>
Date: Fri, 24 Oct 2008 16:55:49 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Badari Pulavarty <pbadari@gmail.com>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-git7 compile error (ppc)
References: <1224265634.15582.3.camel@badari-desktop> <1224267073.15582.8.camel@badari-desktop> <FEFFA236-AA3B-49F1-AED2-E42950B87BD7@kernel.crashing.org> <200810250054.05849.rjw@sisk.pl>
In-Reply-To: <200810250054.05849.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2008 22:55:51.0653 (UTC) FILETIME=[A9C51950:01C9362B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 17 of October 2008, Kumar Gala wrote:

>> I've got a patch that seems to address this for me building w/ 
>> CONFIG_RELOCATABLE on ppc32/85xx.
> 
> Has that been fixed in 2.6.27 and/or current mainline?

I think CONFIG_RELOCATABLE was introduced post 2.6.27, so shouldn't be a 
problem in that version.

Chris

