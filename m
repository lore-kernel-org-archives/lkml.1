Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYCKT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYCKT5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYCKT5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:57:15 -0400
Received: from phunq.net ([64.81.85.152]:40173 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751158AbYCKT5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:57:15 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Tue, 11 Mar 2008 11:56:50 -0800
User-Agent: KMail/1.9.5
Cc: Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <47D6C0A8.6010504@nortel.com>
In-Reply-To: <47D6C0A8.6010504@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111256.51267.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 10:26, Chris Friesen wrote:
> I have experienced many 2.6 crashes due to software flaws.  Hung 
> processes leading to watchdog timeouts, bad kernel pointers, kernel 
> deadlock, etc.
> 
> When designing for reliable embedded systems it's not enough to handwave 
> away the possibility of software flaws.

Indeed.  You fix them.  Which 2.6 kernel version failed for you, what
made it fail, and does the latest version still fail?

If Linux is not reliable then we are doomed and I do not care about
whether my ramback fails because I will just slit my wrists anyway.
How about you?

Daniel
