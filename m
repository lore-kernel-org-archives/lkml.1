Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbYAVTcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYAVTcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYAVTcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:32:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYAVTcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:32:48 -0500
Message-ID: <479644DB.6010807@redhat.com>
Date: Tue, 22 Jan 2008 14:32:43 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: vojtech@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: Linux and remote control device
References: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
In-Reply-To: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2008 03:01 AM, Francis Moreau wrote:
> Hello,
> 
> I'd like to add support for my Infrared remote control to Linux.
> 
> So far I only see LIRCD project that make the kernel support
> such device but I'm not sure if this project is the best choice
> since it's not part of mainline kernels. And there are certainly
> good reasons which I'm not aware of.
> 

lirc is being worked on and is nearly ready for upstream submission.

