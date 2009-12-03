Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZLCRgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZLCRgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZLCRgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:36:10 -0500
Received: from lucidpixels.com ([75.144.35.66]:41191 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZLCRgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:36:09 -0500
Date: Thu, 3 Dec 2009 12:36:16 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: What is the performance when using frame pointers in the kernel?
Message-ID: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What is the performance hit when the kernel is compiled with frame 
pointers?

Justin.
