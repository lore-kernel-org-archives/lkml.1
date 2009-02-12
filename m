Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZBLVDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZBLVDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZBLVDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:03:33 -0500
Received: from mail-ausfall.charite.de ([193.175.70.131]:48030 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZBLVDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:03:32 -0500
Date: Thu, 12 Feb 2009 22:03:30 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acer Aspire One fan control
Message-ID: <20090212210330.GH12846@charite.de>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
References: <cone.1234471033.988571.5384.1000@mentalhome>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1234471033.988571.5384.1000@mentalhome>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Feuerer <peter@piie.net>:
> Hi list,
>
> I own such an Acer Aspire One netbook and the noisy fan annoyed me. (The  
> default hardware controlled fan is on all the time). So I wrote a small  
> kernel module which monitors the temperature of the cpu and turns the fan 
> on and off. After testing it a while on my and some of my friends 
> netbooks, it seems to be stable and I thought about submitting this 
> functionality to the mainline kernel. As this is my first time, I've got 
> some questions and would really appreciate any help.

There's a userspace program for that. So why add a kernel module?
