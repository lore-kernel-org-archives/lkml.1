Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589Ab0AUPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0AUPic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981Ab0AUPib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:38:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50209 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750985Ab0AUPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:38:30 -0500
Date: Thu, 21 Jan 2010 10:38:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Tomas M." <tmezzadra@gmail.com>
cc: Corbin Simpson <mostawesomedude@gmail.com>,
       James Simmons <jsimmons@infradead.org>,
       <dri-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Font selection with i915
In-Reply-To: <4B57BCDA.1070705@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1001211037220.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Tomas M. wrote:

> since 2.6.32 you can change the resolution with video=VGA-1:640x480 boot 
> parameter and emulate the old behaviour.

That works even with Fedora-12, which uses a 2.6.31-based kernel.  
Thanks.

Alan Stern

