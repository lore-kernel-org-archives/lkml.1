Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbXEQSd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbXEQSd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbXEQSdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:33:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXEQSds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:33:48 -0400
Message-ID: <464CA006.2080501@zytor.com>
Date: Thu, 17 May 2007 11:33:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Claas Langbehn <claas@rootdir.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <464C4A22.7040709@rootdir.de>
In-Reply-To: <464C4A22.7040709@rootdir.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Claas Langbehn wrote:
> 
> Now my question is:
> 
> Would it be possible to override the BIOS settings of cx8 and nx and
> activate it with linux anyway?
> The CPU supports it and I don't see any reason to disable it.
> 

Yes, that code is already in the git.newsetup tree.

	-hpa
