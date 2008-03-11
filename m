Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYCKFW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYCKFW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYCKFWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:22:17 -0400
Received: from phunq.net ([64.81.85.152]:53394 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368AbYCKFWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:22:16 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 10 Mar 2008 21:22:14 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <20080311050638.GA12498@kroah.com>
In-Reply-To: <20080311050638.GA12498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102222.15230.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 22:06, Greg KH wrote:
> On Sun, Mar 09, 2008 at 10:46:16PM -0800, Daniel Phillips wrote:
> > Set ramback to flush mode:
> > 
> >   echo 1 >/proc/driver/ramback/<devname>
> 
> /proc is so 1990's.  As your code has nothing to do with processes,
> please don't add new files in /proc/.  sysfs is there for you to do
> stuff like this.

Demonstrate some advantage and I will think about it.

Daniel
