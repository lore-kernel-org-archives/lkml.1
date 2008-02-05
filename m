Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYBEWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYBEWdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYBEWdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:33:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYBEWde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:33:34 -0500
Message-ID: <47A8E427.6040205@zytor.com>
Date: Tue, 05 Feb 2008 14:33:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: thomas@m3y3r.de
CC: linux-kernel@vger.kernel.org
Subject: Re: Latest kernel doesn't boot
References: <1202249704.47a8dfe89a99c@213.133.104.17>
In-Reply-To: <1202249704.47a8dfe89a99c@213.133.104.17>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thomas@m3y3r.de wrote:
> The latest linux kernel doesn't boot on my computer
> (h=21511abd0a248a3f225d3b611cfabb93124605a7).
> 
> elilo hangs while booting this kernel. 2.6.24 works.

Wow, so we know it's affected with EFI, since you're using elilo.

You gave absolutely zero other information about your system or what 
"doesn't boot" mean.

	-hpa
