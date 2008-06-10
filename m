Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYFJWo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYFJWo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbYFJWoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:44:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbYFJWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:44:19 -0400
Message-ID: <484F03BB.7080401@zytor.com>
Date: Tue, 10 Jun 2008 15:44:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: devzero@web.de
CC: keith@karsites.net, linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
References: <311993399@web.de>
In-Reply-To: <311993399@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> 
> no, but i`m sure that this is not related to edd.
> 
> not sure if this is fedora specific, but it seems so - see for example:
> 
> http://blogs.gnome.org/diegoe/2008/04/10/vesamenuc32-attempted-dos-system-call/
> 
> maybe some issue with the vesa bios probe for getting video mode information or switching to appropriate mode.
> 
> cc`ing hpa - maybe he as a clue.....
> 

This message usually means your vesamenu.c32 is out of sync with the 
underlying Syslinux version.

If that is not an issue, there is virtually no information in that blog 
(lovely to use a blog instead of filing a proper bug report) that one 
can hang a hat on.

	-hpa
