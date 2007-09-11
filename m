Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbXIKVr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbXIKVr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbXIKVrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:47:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:54561 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbXIKVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:47:48 -0400
Subject: Re: [PATCH 1/4] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200709112107.53155.vda.linux@googlemail.com>
References: <200709112105.34301.vda.linux@googlemail.com>
	 <200709112107.53155.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 14:47:39 -0700
Message-Id: <1189547259.20371.19.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 21:07 +0100, Denys Vlasenko wrote:
> This patch is needed for --gc-sections to work, regardless
> of which final form that support will have.
> 
> This patch renames .text.xxx and .data.xxx sections
> into .xxx.text and .xxx.data, respectively.

I think you'll have better luck with this if you focus on a single
architecture (i386 would be best) .. 

Daniel

