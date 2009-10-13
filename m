Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbZJMX4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbZJMX4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbZJMX4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:56:10 -0400
Received: from lucidpixels.com ([75.144.35.66]:49766 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761643AbZJMX4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:56:10 -0400
Date: Tue, 13 Oct 2009 19:55:33 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Question regarding i5/i7 CPUs (1156) - Speed Bins
Message-ID: <alpine.DEB.2.00.0910131953520.29143@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In order to gain the acceleration e.g. 2.93GHz -> 3.6GHz for a single 
thread, does one need to use a cpu daemon?

e.g.,
powernowd - control cpu speed and voltage using 2.6 kernel interface

Or so?

Or does this happen at the BIOS level without the OS' intervention?

Justin.
