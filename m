Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXIMQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXIMQKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXIMQKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:10:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbXIMQKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:10:01 -0400
Message-ID: <46E960CD.7020705@redhat.com>
Date: Thu, 13 Sep 2007 12:09:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <1189616966.31502.75.camel@tara.firmix.at>
In-Reply-To: <1189616966.31502.75.camel@tara.firmix.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2007 01:09 PM, Bernd Petrovitsch wrote:
> Fedora BTW abandoned kernel-source* and they have now a website with a
> description
> how to produce a configured kernel source tree (e.g. for out-of-tree
> modules).
> 

The kernel-devel package is all that's needed for out-of-tree modules.
